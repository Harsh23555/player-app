import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/multi_thread_download_service.dart';

// ─── Provider ────────────────────────────────────────────────────────────────
final fileManagerProvider =
    StateNotifierProvider.autoDispose<FileManagerNotifier, FileManagerState>(
        (ref) {
  return FileManagerNotifier(ref.watch(multiThreadDownloadServiceProvider));
});

class FileManagerState {
  final String currentPath;
  final List<FileSystemEntity> entries;
  final bool isLoading;
  final Set<String> selected;
  final bool selectionMode;
  final String sortBy; // name, size, date
  final bool sortAsc;

  const FileManagerState({
    required this.currentPath,
    this.entries = const [],
    this.isLoading = false,
    this.selected = const {},
    this.selectionMode = false,
    this.sortBy = 'name',
    this.sortAsc = true,
  });

  FileManagerState copyWith({
    String? currentPath,
    List<FileSystemEntity>? entries,
    bool? isLoading,
    Set<String>? selected,
    bool? selectionMode,
    String? sortBy,
    bool? sortAsc,
  }) =>
      FileManagerState(
        currentPath: currentPath ?? this.currentPath,
        entries: entries ?? this.entries,
        isLoading: isLoading ?? this.isLoading,
        selected: selected ?? this.selected,
        selectionMode: selectionMode ?? this.selectionMode,
        sortBy: sortBy ?? this.sortBy,
        sortAsc: sortAsc ?? this.sortAsc,
      );
}

class FileManagerNotifier extends StateNotifier<FileManagerState> {
  final MultiThreadDownloadService _service;

  FileManagerNotifier(this._service)
      : super(const FileManagerState(currentPath: '')) {
    _init();
  }

  Future<void> _init() async {
    final dir = await _service.downloadDirectory;
    await loadDirectory(dir);
  }

  Future<void> loadDirectory(String path) async {
    state = state.copyWith(currentPath: path, isLoading: true);
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) {
        state = state.copyWith(entries: [], isLoading: false);
        return;
      }
      final entries = dir.listSync(followLinks: false);
      final sorted = _sortEntries(entries, state.sortBy, state.sortAsc);
      state = state.copyWith(entries: sorted, isLoading: false);
    } catch (e) {
      state = state.copyWith(entries: [], isLoading: false);
    }
  }

  List<FileSystemEntity> _sortEntries(
      List<FileSystemEntity> entries, String by, bool asc) {
    final dirs = entries.whereType<Directory>().toList();
    final files = entries.whereType<File>().toList();

    int comparator(FileSystemEntity a, FileSystemEntity b) {
      switch (by) {
        case 'size':
          final sa = a is File ? a.statSync().size : 0;
          final sb = b is File ? b.statSync().size : 0;
          return asc ? sa.compareTo(sb) : sb.compareTo(sa);
        case 'date':
          final da = a.statSync().modified;
          final db = b.statSync().modified;
          return asc ? da.compareTo(db) : db.compareTo(da);
        default:
          return asc
              ? p.basename(a.path).compareTo(p.basename(b.path))
              : p.basename(b.path).compareTo(p.basename(a.path));
      }
    }

    dirs.sort(comparator);
    files.sort(comparator);
    return [...dirs, ...files];
  }

  void toggleSelection(String path) {
    final sel = Set<String>.from(state.selected);
    if (sel.contains(path)) {
      sel.remove(path);
    } else {
      sel.add(path);
    }
    state = state.copyWith(
        selected: sel, selectionMode: sel.isNotEmpty);
  }

  void clearSelection() {
    state = state.copyWith(selected: {}, selectionMode: false);
  }

  Future<void> deleteSelected() async {
    for (final path in state.selected) {
      try {
        final entity = FileSystemEntity.isDirectorySync(path)
            ? Directory(path)
            : File(path);
        await entity.delete(recursive: true);
      } catch (_) {}
    }
    clearSelection();
    await loadDirectory(state.currentPath);
  }

  Future<void> renameFile(String oldPath, String newName) async {
    try {
      final dir = p.dirname(oldPath);
      final ext = p.extension(oldPath);
      final newPath = p.join(dir, newName.endsWith(ext) ? newName : '$newName$ext');
      await File(oldPath).rename(newPath);
      await loadDirectory(state.currentPath);
    } catch (_) {}
  }

  Future<void> moveFiles(String destDir) async {
    for (final path in state.selected) {
      try {
        final dest = p.join(destDir, p.basename(path));
        await File(path).rename(dest);
      } catch (_) {}
    }
    clearSelection();
    await loadDirectory(state.currentPath);
  }

  void setSortBy(String by, bool asc) {
    final sorted = _sortEntries(state.entries, by, asc);
    state = state.copyWith(sortBy: by, sortAsc: asc, entries: sorted);
  }

  void navigateUp() {
    final parent = p.dirname(state.currentPath);
    if (parent != state.currentPath) {
      loadDirectory(parent);
    }
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────
/// Issue 026 — File Manager + Issue 027 — Storage Analyzer
class FileManagerScreen extends ConsumerWidget {
  const FileManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileManagerProvider);
    final notifier = ref.read(fileManagerProvider.notifier);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('File Manager', style: TextStyle(fontSize: 16)),
                Text(
                  p.basename(state.currentPath).isEmpty
                      ? 'Downloads'
                      : p.basename(state.currentPath),
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.darkTextSecondary),
                ),
              ],
            ),
            actions: [
              if (state.selectionMode) ...[
                IconButton(
                  icon: const Icon(Icons.drive_file_move_rounded),
                  tooltip: 'Move',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share_rounded),
                  tooltip: 'Share',
                  onPressed: () => _shareSelected(context, state),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, notifier),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: notifier.clearSelection,
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.arrow_upward_rounded),
                  tooltip: 'Go Up',
                  onPressed: notifier.navigateUp,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort_rounded),
                  onSelected: (v) {
                    final parts = v.split('_');
                    notifier.setSortBy(parts[0], parts[1] == 'asc');
                  },
                  itemBuilder: (_) => [
                    for (final (key, label) in [
                      ('name', 'Name'),
                      ('size', 'Size'),
                      ('date', 'Date'),
                    ]) ...[
                      PopupMenuItem(
                        value: '${key}_asc',
                        child: Text('$label (A → Z)'),
                      ),
                      PopupMenuItem(
                        value: '${key}_desc',
                        child: Text('$label (Z → A)'),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ],
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.entries.isEmpty
                ? _EmptyFolder()
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.entries.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 64),
                    itemBuilder: (ctx, i) {
                      final entity = state.entries[i];
                      final isSelected =
                          state.selected.contains(entity.path);
                      return _FileTile(
                        entity: entity,
                        isSelected: isSelected,
                        selectionMode: state.selectionMode,
                        onTap: () {
                          if (state.selectionMode) {
                            notifier.toggleSelection(entity.path);
                          } else if (entity is Directory) {
                            notifier.loadDirectory(entity.path);
                          } else {
                            OpenFile.open(entity.path);
                          }
                        },
                        onLongPress: () => notifier.toggleSelection(entity.path),
                        onRename: (name) => notifier.renameFile(entity.path, name),
                        onDelete: () async {
                          await entity.delete(recursive: true);
                          notifier.loadDirectory(state.currentPath);
                        },
                        onShare: () => Share.shareXFiles(
                            [XFile(entity.path)],
                            subject: p.basename(entity.path)),
                      );
                    },
                  ),
      ),
    );
  }

  Future<void> _shareSelected(
      BuildContext context, FileManagerState state) async {
    final files = state.selected
        .where((p) => File(p).existsSync())
        .map((p) => XFile(p))
        .toList();
    if (files.isNotEmpty) {
      await Share.shareXFiles(files);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, FileManagerNotifier notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Files?'),
        content: Consumer(
          builder: (ctx2, ref2, _) => Text(
            'Delete ${ref2.read(fileManagerProvider).selected.length} selected items?',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) await notifier.deleteSelected();
  }
}

class _FileTile extends StatelessWidget {
  final FileSystemEntity entity;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final void Function(String) onRename;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const _FileTile({
    required this.entity,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onRename,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDir = entity is Directory;
    final name = p.basename(entity.path);
    final stat = entity.statSync();
    final ext = isDir ? '' : p.extension(name).toLowerCase();
    final (icon, color) = _iconAndColor(isDir, ext);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryViolet.withOpacity(0.2)
              : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppTheme.primaryViolet, width: 1.5)
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: AppTheme.primaryViolet)
            : Icon(icon, color: color, size: 22),
      ),
      title: Text(name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        isDir
            ? 'Folder'
            : '${_formatBytes(stat.size)} • ${_formatDate(stat.modified)}',
        style: const TextStyle(fontSize: 11, color: AppTheme.darkTextSecondary),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: selectionMode
          ? null
          : PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 18),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'open', child: Text('Open')),
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete',
                        style: TextStyle(color: Colors.red))),
              ],
              onSelected: (action) {
                switch (action) {
                  case 'open':
                    if (isDir) {
                      // handled by parent
                    } else {
                      OpenFile.open(entity.path);
                    }
                    break;
                  case 'rename':
                    _showRenameDialog(context, name);
                    break;
                  case 'share':
                    onShare();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
            ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, String currentName) async {
    final ctrl = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Rename')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      onRename(result);
    }
  }

  (IconData, Color) _iconAndColor(bool isDir, String ext) {
    if (isDir) return (Icons.folder_rounded, AppTheme.accentGold);
    switch (ext) {
      case '.mp4':
      case '.mkv':
      case '.avi':
      case '.mov':
      case '.webm':
        return (Icons.videocam_rounded, AppTheme.accentCyan);
      case '.mp3':
      case '.aac':
      case '.flac':
      case '.wav':
      case '.ogg':
      case '.m4a':
        return (Icons.music_note_rounded, AppTheme.primaryViolet);
      case '.pdf':
        return (Icons.picture_as_pdf_rounded, Colors.red);
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
      case '.webp':
        return (Icons.image_rounded, Colors.green);
      case '.zip':
      case '.rar':
      case '.7z':
        return (Icons.folder_zip_rounded, Colors.orange);
      case '.apk':
        return (Icons.android_rounded, Colors.green);
      default:
        return (Icons.insert_drive_file_rounded, AppTheme.darkTextSecondary);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _EmptyFolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_rounded,
              size: 72, color: AppTheme.darkTextMuted),
          const SizedBox(height: 16),
          const Text('Empty Folder',
              style: TextStyle(color: AppTheme.darkTextSecondary, fontSize: 16)),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}

// Removed duplicate StorageAnalyzerScreen here.
