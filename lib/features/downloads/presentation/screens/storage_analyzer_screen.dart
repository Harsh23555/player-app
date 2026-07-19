import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/storage_analyzer_service.dart';
import '../../../../shared/widgets/common_widgets.dart';

final _analysisProvider = FutureProvider<StorageAnalysis>((ref) async {
  final service = ref.watch(storageAnalyzerProvider);
  return service.analyze();
});

/// Issue 027 — Storage Analyzer Screen
class StorageAnalyzerScreen extends ConsumerWidget {
  const StorageAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(_analysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Analyzer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(_analysisProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: analysisAsync.when(
        data: (analysis) => _StorageAnalyzerBody(analysis: analysis),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _StorageAnalyzerBody extends ConsumerStatefulWidget {
  final StorageAnalysis analysis;
  const _StorageAnalyzerBody({required this.analysis});

  @override
  ConsumerState<_StorageAnalyzerBody> createState() => _StorageAnalyzerBodyState();
}

class _StorageAnalyzerBodyState extends ConsumerState<_StorageAnalyzerBody> {
  @override
  Widget build(BuildContext context) {
    final analysis = widget.analysis;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Storage Overview ─────────────────────────────────────────
              _sectionTitle('Storage Overview'),
              const SizedBox(height: 12),
              _buildStorageCard(analysis).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 20),

              // ── Downloads Stats ──────────────────────────────────────────
              _sectionTitle('Downloads'),
              const SizedBox(height: 12),
              _buildDownloadsCard(analysis).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 20),

              // ── Category Breakdown ────────────────────────────────────────
              if (analysis.categoryBreakdown.isNotEmpty) ...[
                _sectionTitle('Category Breakdown'),
                const SizedBox(height: 12),
                _buildCategoryPieChart(analysis).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                const SizedBox(height: 20),
              ],

              // ── Large Files ───────────────────────────────────────────────
              if (analysis.largeFiles.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionTitle('Large Files', sizedBox: false),
                    Text(
                      '${analysis.largeFiles.length} files',
                      style: TextStyle(
                          color: AppTheme.darkTextMuted, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...analysis.largeFiles.take(10).map((f) =>
                    _buildFileRow(context, f, ref)
                        .animate(delay: Duration(milliseconds: analysis.largeFiles.indexOf(f) * 20))
                        .fadeIn()
                        .slideX(begin: 0.05)),
                const SizedBox(height: 20),
              ],

              // ── Duplicates ────────────────────────────────────────────────
              if (analysis.duplicates.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionTitle('Duplicate Files', sizedBox: false),
                    TextButton.icon(
                      icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                      label: const Text('Clean All'),
                      onPressed: () => _cleanDuplicates(context, ref, analysis.duplicates),
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.accentPink),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...analysis.duplicates.map((group) => _buildDuplicateGroup(context, group, ref)),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, {bool sizedBox = true}) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: AppTheme.primaryViolet,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildStorageCard(StorageAnalysis a) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Usage bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: a.usedPercent,
                minHeight: 16,
                backgroundColor: AppTheme.darkBorder,
                valueColor: AlwaysStoppedAnimation(
                    _usageColor(a.usedPercent)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _storageInfo('Total', a.formattedTotal, AppTheme.darkTextSecondary),
                _storageInfo('Used', a.formattedUsed, AppTheme.accentPink),
                _storageInfo('Free', a.formattedFree, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _storageInfo(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  TextStyle(color: AppTheme.darkTextMuted, fontSize: 11)),
        ],
      ),
    );
  }

  Color _usageColor(double percent) {
    if (percent < 0.6) return Colors.green;
    if (percent < 0.8) return AppTheme.accentGold;
    return AppTheme.accentPink;
  }

  Widget _buildDownloadsCard(StorageAnalysis a) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryViolet.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.download_rounded,
                  color: AppTheme.primaryViolet, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.formattedDownloads,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryViolet,
                        ),
                  ),
                  Text(
                    '${a.totalFiles} files in downloads',
                    style: TextStyle(
                        color: AppTheme.darkTextMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(StorageAnalysis a) {
    final breakdown = a.categoryBreakdown;
    final total =
        breakdown.values.fold<int>(0, (s, v) => s + v);
    const colors = [
      AppTheme.accentCyan,
      AppTheme.primaryViolet,
      AppTheme.accentGold,
      Colors.green,
      Colors.orange,
      AppTheme.accentPink,
      Colors.teal,
    ];

    final entries = breakdown.entries.toList();

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: PieChart(PieChartData(
                sections: entries.indexed.map((e) {
                  final idx = e.$1;
                  final entry = e.$2;
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: colors[idx % colors.length],
                    title: '',
                    radius: 50,
                  );
                }).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.indexed
                    .map((e) => _legendItem(
                          e.$2.key,
                          _fmt(e.$2.value),
                          total > 0
                              ? (e.$2.value / total * 100).toStringAsFixed(1)
                              : '0',
                          colors[e.$1 % colors.length],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, String size, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: AppTheme.darkTextSecondary, fontSize: 12))),
          Text('$percent%',
              style: TextStyle(
                  color: AppTheme.darkTextMuted, fontSize: 11)),
          const SizedBox(width: 4),
          Text(size,
              style: TextStyle(
                  color: AppTheme.darkTextPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFileRow(BuildContext context, FileInfo file, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(_iconForExt(file.extension),
              color: AppTheme.accentCyan, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(file.formattedSize,
                    style: TextStyle(
                        color: AppTheme.accentCyan, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.red, size: 18),
            onPressed: () => _confirmDelete(context, ref, file),
          ),
        ],
      ),
    );
  }

  Widget _buildDuplicateGroup(
      BuildContext context, List<FileInfo> group, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${group.length} duplicates',
              style: TextStyle(
                  color: AppTheme.accentPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...group.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(_iconForExt(f.extension),
                        size: 14, color: AppTheme.darkTextMuted),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(f.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppTheme.darkTextSecondary,
                                fontSize: 12))),
                    Text(f.formattedSize,
                        style: TextStyle(
                            color: AppTheme.darkTextMuted, fontSize: 11)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, FileInfo file) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File?'),
        content: Text('Delete "${file.name}"?\nThis cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true && mounted) {
      final service = ref.read(storageAnalyzerProvider);
      await service.deleteFile(file.path);
      ref.invalidate(_analysisProvider);
    }
  }

  Future<void> _cleanDuplicates(BuildContext context, WidgetRef ref,
      List<List<FileInfo>> duplicates) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clean Duplicates?'),
        content: Text(
            'Remove ${duplicates.fold(0, (s, g) => s + g.length - 1)} duplicate files?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child:
                  const Text('Clean', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true && mounted) {
      final service = ref.read(storageAnalyzerProvider);
      final deleted = await service.cleanDuplicates(duplicates);
      ref.invalidate(_analysisProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted $deleted duplicate files')),
        );
      }
    }
  }

  IconData _iconForExt(String ext) {
    const videos = ['mp4', 'mkv', 'avi', 'mov', 'webm'];
    const audios = ['mp3', 'aac', 'flac', 'wav', 'm4a'];
    const images = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    const docs = ['pdf', 'doc', 'docx', 'txt'];
    const archives = ['zip', 'rar', '7z', 'tar', 'iso'];
    if (videos.contains(ext)) return Icons.videocam_rounded;
    if (audios.contains(ext)) return Icons.music_note_rounded;
    if (images.contains(ext)) return Icons.image_rounded;
    if (docs.contains(ext)) return Icons.description_rounded;
    if (archives.contains(ext)) return Icons.folder_zip_rounded;
    if (ext == 'apk') return Icons.android_rounded;
    return Icons.insert_drive_file_rounded;
  }

  String _fmt(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
