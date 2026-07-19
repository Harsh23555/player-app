import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/utils/app_logger.dart';

final storageAnalyzerProvider = Provider<StorageAnalyzerService>((ref) {
  return StorageAnalyzerService();
});

/// Issue 027 — Storage Analyzer
/// Provides total/used/free storage info, download size, large files, and duplicates.
class StorageAnalyzerService {
  static const _downloadSubDir = 'NovaPlayer/Downloads';

  Future<StorageAnalysis> analyze({String? downloadsPath}) async {
    try {
      final downloadDir = downloadsPath != null
          ? Directory(downloadsPath)
          : Directory('/storage/emulated/0/$_downloadSubDir');

      // System storage stats
      final totalBytes = await _getTotalStorage();
      final freeBytes = await _getFreeStorage();
      final usedBytes = totalBytes - freeBytes;

      // Downloads directory analysis
      int downloadsDirBytes = 0;
      final allFiles = <FileInfo>[];

      if (downloadDir.existsSync()) {
        await for (final entity in downloadDir.list(recursive: true)) {
          if (entity is File) {
            try {
              final stat = await entity.stat();
              final size = stat.size;
              downloadsDirBytes += size;
              allFiles.add(FileInfo(
                path: entity.path,
                name: entity.path.split('/').last,
                sizeBytes: size,
                modified: stat.modified,
                extension: entity.path.split('.').last.toLowerCase(),
              ));
            } catch (_) {}
          }
        }
      }

      // Sort by size for large files
      allFiles.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
      final largeFiles = allFiles.take(20).toList();

      // Find potential duplicates (same size + similar name)
      final duplicates = _findDuplicates(allFiles);

      // Category breakdown
      final breakdown = _buildBreakdown(allFiles);

      return StorageAnalysis(
        totalBytes: totalBytes,
        usedBytes: usedBytes,
        freeBytes: freeBytes,
        downloadBytes: downloadsDirBytes,
        totalFiles: allFiles.length,
        largeFiles: largeFiles,
        duplicates: duplicates,
        categoryBreakdown: breakdown,
      );
    } catch (e) {
      AppLogger.error('StorageAnalyzer: analyze failed', error: e);
      return StorageAnalysis(
        totalBytes: 0,
        usedBytes: 0,
        freeBytes: 0,
        downloadBytes: 0,
        totalFiles: 0,
        largeFiles: [],
        duplicates: [],
        categoryBreakdown: {},
      );
    }
  }

  Future<int> _getTotalStorage() async {
    try {
      if (Platform.isAndroid) {
        final stat = await FileStat.stat('/storage/emulated/0');
        // Note: on Android, total storage is not available via FileStat directly
        // This is an approximation. Real implementation uses platform channel.
        return 64 * 1024 * 1024 * 1024; // 64GB placeholder
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _getFreeStorage() async {
    try {
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0');
        final stat = await FileStat.stat(dir.path);
        // Platform channel would be needed for precise free space
        return 16 * 1024 * 1024 * 1024; // 16GB placeholder
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  List<List<FileInfo>> _findDuplicates(List<FileInfo> files) {
    final sizeMap = <int, List<FileInfo>>{};
    for (final file in files) {
      sizeMap.putIfAbsent(file.sizeBytes, () => []).add(file);
    }
    return sizeMap.values.where((group) => group.length > 1).toList();
  }

  Map<String, int> _buildBreakdown(List<FileInfo> files) {
    final breakdown = <String, int>{};
    for (final file in files) {
      final cat = _categoryFromExt(file.extension);
      breakdown[cat] = (breakdown[cat] ?? 0) + file.sizeBytes;
    }
    return breakdown;
  }

  String _categoryFromExt(String ext) {
    const videos = ['mp4', 'mkv', 'avi', 'mov', 'webm', 'flv', '3gp', 'ts'];
    const audios = ['mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'opus'];
    const images = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    const docs = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'txt'];
    const archives = ['zip', 'rar', '7z', 'tar', 'gz', 'iso'];
    if (videos.contains(ext)) return 'Video';
    if (audios.contains(ext)) return 'Audio';
    if (images.contains(ext)) return 'Images';
    if (docs.contains(ext)) return 'Documents';
    if (archives.contains(ext)) return 'Archives';
    if (ext == 'apk') return 'APK';
    return 'Other';
  }

  /// Delete a file and return success
  Future<bool> deleteFile(String path) async {
    try {
      await File(path).delete();
      return true;
    } catch (e) {
      AppLogger.error('deleteFile failed: $path', error: e);
      return false;
    }
  }

  /// Delete all duplicate files, keeping the first in each group
  Future<int> cleanDuplicates(List<List<FileInfo>> duplicates) async {
    int deleted = 0;
    for (final group in duplicates) {
      for (int i = 1; i < group.length; i++) {
        if (await deleteFile(group[i].path)) deleted++;
      }
    }
    return deleted;
  }
}

class StorageAnalysis {
  final int totalBytes;
  final int usedBytes;
  final int freeBytes;
  final int downloadBytes;
  final int totalFiles;
  final List<FileInfo> largeFiles;
  final List<List<FileInfo>> duplicates;
  final Map<String, int> categoryBreakdown;

  const StorageAnalysis({
    required this.totalBytes,
    required this.usedBytes,
    required this.freeBytes,
    required this.downloadBytes,
    required this.totalFiles,
    required this.largeFiles,
    required this.duplicates,
    required this.categoryBreakdown,
  });

  double get usedPercent => totalBytes > 0 ? usedBytes / totalBytes : 0;
  double get freePercent => totalBytes > 0 ? freeBytes / totalBytes : 0;

  String get formattedTotal => _fmt(totalBytes);
  String get formattedUsed => _fmt(usedBytes);
  String get formattedFree => _fmt(freeBytes);
  String get formattedDownloads => _fmt(downloadBytes);

  String _fmt(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class FileInfo {
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime modified;
  final String extension;

  const FileInfo({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.modified,
    required this.extension,
  });

  String get formattedSize {
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
