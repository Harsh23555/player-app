import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/repositories/download_history_repository.dart';
import '../../../../data/models/db/download_entity.dart';
import '../../../../shared/widgets/common_widgets.dart';

final _historyListProvider =
    StateNotifierProvider<DownloadHistoryNotifier, List<DownloadHistoryEntity>>((ref) {
  return DownloadHistoryNotifier(ref.watch(downloadHistoryRepositoryProvider));
});

class DownloadHistoryNotifier extends StateNotifier<List<DownloadHistoryEntity>> {
  final DownloadHistoryRepository _repo;
  List<DownloadHistoryEntity> _all = [];

  DownloadHistoryNotifier(this._repo) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    _all = await _repo.getAll();
    state = _all;
  }

  void search(String query) {
    if (query.isEmpty) {
      state = _all;
    } else {
      final q = query.toLowerCase();
      state = _all
          .where((e) =>
              e.fileName.toLowerCase().contains(q) ||
              e.url.toLowerCase().contains(q))
          .toList();
    }
  }

  Future<void> deleteItem(int id) async {
    await _repo.delete(id);
    await refresh();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    await refresh();
  }

  Future<void> exportHistory(BuildContext context) async {
    try {
      final json = await _repo.exportJson();
      final tempDir = await Directory.systemTemp.createTemp();
      final file = File('${tempDir.path}/nova_download_history.json');
      await file.writeAsString(json);
      await Share.shareXFiles([XFile(file.path)], text: 'Nova Player Download History');
    } catch (_) {}
  }

  Future<bool> importHistory() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null && result.files.single.path != null) {
        final content = await File(result.files.single.path!).readAsString();
        final success = await _repo.importJson(content);
        if (success) await refresh();
        return success;
      }
    } catch (_) {}
    return false;
  }
}

/// Issue 008 — Download History Screen
class DownloadHistoryScreen extends ConsumerStatefulWidget {
  const DownloadHistoryScreen({super.key});

  @override
  ConsumerState<DownloadHistoryScreen> createState() => _DownloadHistoryScreenState();
}

class _DownloadHistoryScreenState extends ConsumerState<DownloadHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(_historyListProvider);
    final notifier = ref.read(_historyListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) async {
              if (val == 'clear') {
                final confirm = await _showConfirmClear();
                if (confirm == true) {
                  await notifier.clearAll();
                }
              } else if (val == 'export') {
                await notifier.exportHistory(context);
              } else if (val == 'import') {
                final ok = await notifier.importHistory();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(ok ? 'History imported successfully' : 'Failed to import history'),
                  ));
                }
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.download_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Import History'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.upload_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Export History'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Clear All', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: NovaSearchBar(
              hint: 'Search downloads history...',
              controller: _searchController,
              onChanged: notifier.search,
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? const EmptyState(
                    icon: Icons.history_rounded,
                    title: 'No History',
                    subtitle: 'Your search or download history is empty.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final item = history[i];
                      return _HistoryRow(item: item, index: i);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmClear() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('Are you sure you want to clear your entire download history? This will not delete the local files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends ConsumerWidget {
  final DownloadHistoryEntity item;
  final int index;

  const _HistoryRow({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryViolet.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.done_all_rounded, color: AppTheme.primaryViolet, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _fmtSize(item.totalBytes),
                      style: TextStyle(color: AppTheme.darkTextMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: AppTheme.darkTextMuted, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      _fmtDate(item.completedAt),
                      style: TextStyle(color: AppTheme.darkTextMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 20),
            onPressed: () => ref.read(_historyListProvider.notifier).deleteItem(item.id),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 25))
        .fadeIn()
        .slideX(begin: 0.05);
  }

  String _fmtSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _fmtDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
