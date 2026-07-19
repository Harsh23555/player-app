import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/models/download_model.dart';
import '../../../../data/services/clipboard_service.dart';
import '../../../../data/services/multi_thread_download_service.dart';
import '../../providers/download_manager_provider.dart';
import '../../../../shared/widgets/common_widgets.dart';
import 'add_download_sheet.dart';
import 'schedule_download_sheet.dart';

class DownloadManagerScreen extends ConsumerStatefulWidget {
  const DownloadManagerScreen({super.key});

  @override
  ConsumerState<DownloadManagerScreen> createState() =>
      _DownloadManagerScreenState();
}

class _DownloadManagerScreenState extends ConsumerState<DownloadManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription? _clipboardSub;
  String _searchQuery = '';
  bool _isSearching = false;
  String _sortBy = 'date'; // date, name, size, speed
  String _filterType = 'all'; // all, video, audio, document, image, archive

  final _tabs = [
    ('Active', Icons.downloading_rounded),
    ('Queue', Icons.queue_rounded),
    ('Paused', Icons.pause_circle_rounded),
    ('Done', Icons.check_circle_rounded),
    ('Failed', Icons.error_rounded),
    ('Scheduled', Icons.schedule_rounded),
    ('All', Icons.history_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadManagerProvider.notifier).loadDownloads();
      _startClipboardMonitoring();
    });
  }

  void _startClipboardMonitoring() {
    final clipboardService = ref.read(clipboardServiceProvider);
    clipboardService.startMonitoring();
    _clipboardSub = clipboardService.urlStream.listen((url) {
      if (mounted) _showClipboardSnackbar(url);
    });
  }

  void _showClipboardSnackbar(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.link_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'URL detected: ${_truncate(url, 40)}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Download',
          onPressed: () => _openAddSheet(initialUrl: url),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clipboardSub?.cancel();
    ref.read(clipboardServiceProvider).stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(downloadManagerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: _isSearching ? _buildSearchField() : const Text('Downloads'),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
                onPressed: () => setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) _searchQuery = '';
                }),
              ),
              IconButton(
                icon: const Icon(Icons.sort_rounded),
                onPressed: () => _showSortFilter(context),
                tooltip: 'Sort & Filter',
              ),
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                onPressed: () => _showAnalytics(context, state),
                tooltip: 'Analytics',
              ),
              IconButton(
                icon: const Icon(Icons.folder_rounded),
                onPressed: () => context.push(AppRoutes.fileManager),
                tooltip: 'File Manager',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppTheme.accentPink,
                labelColor: AppTheme.accentPink,
                unselectedLabelColor: AppTheme.darkTextSecondary,
                tabs: _tabs.map((tab) {
                  final count = _getTabCount(tab.$1, state);
                  return Tab(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(tab.$2, size: 15),
                      const SizedBox(width: 5),
                      Text(tab.$1),
                      if (count > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ]
                    ]),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildList(context, _filterDownloads(state.active, state), 'active'),
                  _buildList(context, _filterDownloads(state.queued, state), 'queued'),
                  _buildList(context, _filterDownloads(state.paused, state), 'paused'),
                  _buildList(context, _filterDownloads(state.completed, state), 'completed'),
                  _buildList(context, _filterDownloads(state.failed, state), 'failed'),
                  _buildList(context, _filterDownloads(state.scheduled, state), 'scheduled'),
                  _buildList(context, _filterDownloads(state.downloads, state), 'all'),
                ],
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'schedule',
            onPressed: () => _openScheduleSheet(),
            backgroundColor: AppTheme.accentGold,
            child: const Icon(Icons.schedule_rounded, color: Colors.black),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'download',
            onPressed: () => _openAddSheet(),
            backgroundColor: AppTheme.primaryViolet,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      onChanged: (v) => setState(() => _searchQuery = v),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search downloads…',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
    );
  }

  List<DownloadModel> _filterDownloads(
      List<DownloadModel> downloads, DownloadManagerState state) {
    var result = downloads;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((d) =>
              d.fileName.toLowerCase().contains(q) ||
              d.url.toLowerCase().contains(q))
          .toList();
    }

    // Type filter
    if (_filterType != 'all') {
      result = result.where((d) => d.fileTypeCategory == _filterType).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'name':
        result.sort((a, b) => a.fileName.compareTo(b.fileName));
        break;
      case 'size':
        result.sort((a, b) => b.totalBytes.compareTo(a.totalBytes));
        break;
      case 'speed':
        result.sort((a, b) => b.speed.compareTo(a.speed));
        break;
      default:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return result;
  }

  Widget _buildList(
      BuildContext context, List<DownloadModel> downloads, String type) {
    if (downloads.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: downloads.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _DownloadTile(
        key: ValueKey(downloads[i].taskId),
        download: downloads[i],
        index: i,
        onPause: () =>
            ref.read(downloadManagerProvider.notifier).pauseDownload(downloads[i].taskId),
        onResume: () =>
            ref.read(downloadManagerProvider.notifier).resumeDownload(downloads[i].taskId),
        onCancel: () =>
            ref.read(downloadManagerProvider.notifier).cancelDownload(downloads[i].taskId),
        onRetry: () =>
            ref.read(downloadManagerProvider.notifier).retryDownload(downloads[i].taskId),
        onDelete: () => _confirmDelete(context, downloads[i]),
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    final (icon, title, subtitle) = _emptyStateContent(type);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: AppTheme.darkTextMuted),
          const SizedBox(height: 16),
          Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.darkTextSecondary)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkTextMuted)),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  (IconData, String, String) _emptyStateContent(String type) {
    switch (type) {
      case 'active':
        return (Icons.downloading_rounded, 'No Active Downloads',
            'Tap + to add a new download');
      case 'queued':
        return (Icons.queue_rounded, 'Queue is Empty',
            'Downloads will queue when max concurrent is reached');
      case 'paused':
        return (Icons.pause_circle_outline_rounded, 'Nothing Paused',
            'Paused downloads appear here');
      case 'completed':
        return (Icons.cloud_done_rounded, 'No Completed Downloads',
            'Finished downloads will appear here');
      case 'failed':
        return (Icons.cloud_off_rounded, 'No Failed Downloads', 'Great!');
      case 'scheduled':
        return (Icons.schedule_rounded, 'No Scheduled Downloads',
            'Tap the clock button to schedule downloads');
      default:
        return (Icons.history_rounded, 'No Downloads Yet',
            'Tap + to start downloading');
    }
  }

  int _getTabCount(String tab, DownloadManagerState state) {
    switch (tab) {
      case 'Active':
        return state.active.length;
      case 'Queue':
        return state.queued.length;
      case 'Paused':
        return state.paused.length;
      case 'Done':
        return state.completed.length;
      case 'Failed':
        return state.failed.length;
      case 'Scheduled':
        return state.scheduled.length;
      default:
        return 0;
    }
  }

  void _openAddSheet({String? initialUrl}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddDownloadSheet(
        initialUrl: initialUrl,
        onDownload: (url, fileName, threads) async {
          final success = await ref
              .read(downloadManagerProvider.notifier)
              .startDownloadWithConfig(
                  url: url, fileName: fileName, threadCount: threads);
          if (success && mounted) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Download started!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  void _openScheduleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ScheduleDownloadSheet(
        onSchedule: (url, fileName, scheduledAt, wifiOnly, chargingOnly) {
          ref.read(downloadManagerProvider.notifier).scheduleDownload(
                url: url,
                fileName: fileName,
                scheduledAt: scheduledAt,
                wifiOnly: wifiOnly,
                chargingOnly: chargingOnly,
              );
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, DownloadModel download) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Download?'),
        content: Text('Remove "${_truncate(download.fileName, 40)}" from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'keep'),
            child: const Text('Keep File'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'delete'),
            child:
                const Text('Delete File', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == 'keep' || result == 'delete') {
      ref.read(downloadManagerProvider.notifier).deleteDownload(
            download.taskId,
            deleteFile: result == 'delete',
          );
    }
  }

  void _showSortFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort by', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final (key, label) in [
                  ('date', 'Date'),
                  ('name', 'Name'),
                  ('size', 'Size'),
                  ('speed', 'Speed'),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _sortBy == key,
                    onSelected: (_) => setState(() {
                      _sortBy = key;
                      Navigator.pop(ctx);
                    }),
                    selectedColor: AppTheme.primaryViolet,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Filter by type',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final (key, label, icon) in [
                  ('all', 'All', Icons.list_rounded),
                  ('video', 'Video', Icons.videocam_rounded),
                  ('audio', 'Audio', Icons.music_note_rounded),
                  ('document', 'Docs', Icons.description_rounded),
                  ('image', 'Images', Icons.image_rounded),
                  ('archive', 'Archives', Icons.folder_zip_rounded),
                  ('apk', 'APK', Icons.android_rounded),
                ])
                  ChoiceChip(
                    label: Text(label),
                    avatar: Icon(icon, size: 14),
                    selected: _filterType == key,
                    onSelected: (_) => setState(() {
                      _filterType = key;
                      Navigator.pop(ctx);
                    }),
                    selectedColor: AppTheme.accentCyan,
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAnalytics(BuildContext context, DownloadManagerState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _AnalyticsPanel(state: state, scrollController: controller),
        ),
      ),
    );
  }

  String _truncate(String s, int max) =>
      s.length > max ? '${s.substring(0, max)}…' : s;
}

// ─────────────────────────────────────────────────────────────────────────────
// Download Tile (Issue 025)
// ─────────────────────────────────────────────────────────────────────────────
class _DownloadTile extends StatelessWidget {
  final DownloadModel download;
  final int index;
  final VoidCallback onPause, onResume, onCancel, onRetry, onDelete;

  const _DownloadTile({
    super.key,
    required this.download,
    required this.index,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(download.status);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildFileIcon(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _StatusBadge(status: download.status),
                        const SizedBox(width: 8),
                        if (download.totalBytes > 0)
                          Text(download.formattedTotalSize,
                              style: Theme.of(context).textTheme.bodySmall),
                        if (download.threadCount > 1) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppTheme.accentCyan.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${download.threadCount}T',
                              style: TextStyle(
                                  color: AppTheme.accentCyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _buildActions(),
            ],
          ),

          // Progress bar
          if (download.isActive || download.isPaused) ...[
            const SizedBox(height: 10),
            LinearPercentIndicator(
              percent: download.progress.clamp(0.0, 1.0),
              lineHeight: 5,
              backgroundColor: AppTheme.darkBorder,
              progressColor: color,
              barRadius: const Radius.circular(3),
              padding: EdgeInsets.zero,
              animation: true,
              animateFromLastPercent: true,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${download.formattedDownloadedSize} / ${download.formattedTotalSize}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  download.isActive
                      ? '${(download.progress * 100).toInt()}% • ${download.formattedSpeed}'
                      : '${(download.progress * 100).toInt()}% - Paused',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkTextMuted,
                      ),
                ),
                if (download.eta > 0 && download.isActive)
                  Text('ETA ${download.formattedEta}',
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],

          // Completion time
          if (download.isComplete && download.completedAt != null) ...[
            const SizedBox(height: 4),
            Text(
              'Completed ${timeago.format(download.completedAt!)} • ${download.formattedTotalSize}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.withOpacity(0.8),
                  ),
            ),
          ],

          // Error
          if (download.isFailed && download.errorMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              download.errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.red),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 30)).fadeIn().slideY(begin: 0.05);
  }

  Widget _buildFileIcon(BuildContext context) {
    final (icon, color) = _fileTypeIcon(download.fileTypeCategory);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (download.isActive)
          _ActionBtn(Icons.pause_rounded, AppTheme.accentGold, onPause, 'Pause'),
        if (download.isPaused)
          _ActionBtn(Icons.play_arrow_rounded, Colors.green, onResume, 'Resume'),
        if (download.isFailed)
          _ActionBtn(Icons.replay_rounded, AppTheme.accentCyan, onRetry, 'Retry'),
        if (download.isActive || download.isPaused)
          _ActionBtn(Icons.cancel_rounded, Colors.red, onCancel, 'Cancel'),
        _ActionBtn(
            Icons.delete_outline_rounded, AppTheme.darkTextMuted, onDelete, 'Delete'),
      ],
    );
  }

  Color _statusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.running:
        return AppTheme.accentCyan;
      case DownloadStatus.enqueued:
        return AppTheme.accentGold;
      case DownloadStatus.complete:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.paused:
        return AppTheme.accentGold;
      case DownloadStatus.canceled:
        return AppTheme.darkTextMuted;
      case DownloadStatus.scheduled:
        return AppTheme.accentPink;
    }
  }

  (IconData, Color) _fileTypeIcon(String category) {
    switch (category) {
      case 'video':
        return (Icons.videocam_rounded, AppTheme.accentCyan);
      case 'audio':
        return (Icons.music_note_rounded, AppTheme.primaryViolet);
      case 'document':
        return (Icons.description_rounded, AppTheme.accentGold);
      case 'image':
        return (Icons.image_rounded, Colors.green);
      case 'archive':
        return (Icons.folder_zip_rounded, Colors.orange);
      case 'apk':
        return (Icons.android_rounded, Colors.green);
      default:
        return (Icons.insert_drive_file_rounded, AppTheme.darkTextSecondary);
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionBtn(this.icon, this.color, this.onPressed, this.tooltip);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 18,
      color: color,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DownloadStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _labelAndColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  (String, Color) _labelAndColor() {
    switch (status) {
      case DownloadStatus.running:
        return ('Downloading', AppTheme.accentCyan);
      case DownloadStatus.enqueued:
        return ('Queued', AppTheme.accentGold);
      case DownloadStatus.complete:
        return ('Complete', Colors.green);
      case DownloadStatus.failed:
        return ('Failed', Colors.red);
      case DownloadStatus.paused:
        return ('Paused', AppTheme.accentGold);
      case DownloadStatus.canceled:
        return ('Canceled', AppTheme.darkTextMuted);
      case DownloadStatus.scheduled:
        return ('Scheduled', AppTheme.accentPink);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Analytics Panel (Issue 029)
// ─────────────────────────────────────────────────────────────────────────────
class _AnalyticsPanel extends StatelessWidget {
  final DownloadManagerState state;
  final ScrollController scrollController;

  const _AnalyticsPanel(
      {required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final all = state.downloads;
    final completed = all.where((d) => d.isComplete).toList();
    final failed = all.where((d) => d.isFailed).toList();
    final totalBytes =
        completed.fold<int>(0, (sum, d) => sum + d.totalBytes);
    final successRate = all.isEmpty
        ? 0
        : (completed.length / all.length * 100).round();

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_outlined, size: 20),
            const SizedBox(width: 8),
            Text('Download Analytics',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 24),

        // Stats grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard('Total Files', '${all.length}', Icons.download_rounded,
                AppTheme.primaryViolet),
            _StatCard('Completed', '${completed.length}',
                Icons.check_circle_rounded, Colors.green),
            _StatCard('Failed', '${failed.length}',
                Icons.error_rounded, Colors.red),
            _StatCard('Success Rate', '$successRate%',
                Icons.trending_up_rounded, AppTheme.accentCyan),
            _StatCard(
              'Total Downloaded',
              _formatBytes(totalBytes),
              Icons.storage_rounded,
              AppTheme.accentGold,
            ),
            _StatCard(
              'Active',
              '${state.active.length}',
              Icons.downloading_rounded,
              AppTheme.accentPink,
            ),
          ],
        ),

        const SizedBox(height: 24),
        Text('File Types', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...['video', 'audio', 'document', 'image', 'archive', 'apk', 'file']
            .map((type) {
          final count =
              all.where((d) => d.fileTypeCategory == type).length;
          if (count == 0) return const SizedBox.shrink();
          final fraction = all.isEmpty ? 0.0 : count / all.length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(type.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkTextSecondary)),
                    Text('$count files',
                        style:
                            const TextStyle(fontSize: 11, color: AppTheme.darkTextMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: fraction,
                  color: _typeColor(type),
                  backgroundColor: AppTheme.darkBorder,
                  borderRadius: BorderRadius.circular(3),
                  minHeight: 6,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'video':
        return AppTheme.accentCyan;
      case 'audio':
        return AppTheme.primaryViolet;
      case 'document':
        return AppTheme.accentGold;
      case 'image':
        return Colors.green;
      case 'archive':
        return Colors.orange;
      case 'apk':
        return Colors.lightGreen;
      default:
        return AppTheme.darkTextSecondary;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.darkTextSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
