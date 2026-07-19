import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/app_logger.dart';
import '../models/download_model.dart';
import '../models/db/download_entity.dart';
import '../repositories/download_repository.dart';

final multiThreadDownloadServiceProvider =
    Provider<MultiThreadDownloadService>((ref) {
  final repo = ref.watch(downloadRepositoryProvider);
  final service = MultiThreadDownloadService(repository: repo);
  ref.onDispose(service.dispose);
  return service;
});

/// Segment state for resumable multi-thread downloads
class SegmentState {
  final int index;
  final int startByte;
  final int endByte;
  int downloadedBytes;
  bool completed;
  String? error;

  SegmentState({
    required this.index,
    required this.startByte,
    required this.endByte,
    this.downloadedBytes = 0,
    this.completed = false,
    this.error,
  });

  int get remainingBytes => (endByte - startByte + 1) - downloadedBytes;
  int get currentByte => startByte + downloadedBytes;

  Map<String, dynamic> toJson() => {
        'index': index,
        'startByte': startByte,
        'endByte': endByte,
        'downloadedBytes': downloadedBytes,
        'completed': completed,
      };

  factory SegmentState.fromJson(Map<String, dynamic> j) => SegmentState(
        index: j['index'],
        startByte: j['startByte'],
        endByte: j['endByte'],
        downloadedBytes: j['downloadedBytes'] ?? 0,
        completed: j['completed'] ?? false,
      );
}

class DownloadTask {
  final String taskId;
  final String url;
  final String fileName;
  final String savePath;
  final int threadCount;
  final int priority;
  DownloadStatus status;
  double progress;
  int totalBytes;
  int downloadedBytes;
  double speed;
  int eta;
  String? errorMessage;
  List<SegmentState> segments;
  CancelToken? cancelToken;
  bool supportsResume;
  DateTime createdAt;
  DateTime? completedAt;

  DownloadTask({
    required this.taskId,
    required this.url,
    required this.fileName,
    required this.savePath,
    this.threadCount = 4,
    this.priority = 0,
    this.status = DownloadStatus.enqueued,
    this.progress = 0,
    this.totalBytes = 0,
    this.downloadedBytes = 0,
    this.speed = 0,
    this.eta = 0,
    this.errorMessage,
    this.segments = const [],
    this.cancelToken,
    this.supportsResume = false,
    required this.createdAt,
    this.completedAt,
  });
}

/// Callback type for progress updates
typedef ProgressCallback = void Function(
    String taskId, DownloadStatus status, double progress, double speed, int eta);

class MultiThreadDownloadService {
  final DownloadRepository _repository;
  final _dio = Dio();
  final _uuid = const Uuid();

  /// Active download tasks
  final Map<String, DownloadTask> _tasks = {};
  final Map<String, List<CancelToken>> _cancelTokens = {};
  ProgressCallback? onProgress;

  static const _downloadSubDir = 'NovaPlayer/Downloads';
  static const _maxAutoThreads = 16;

  MultiThreadDownloadService({required DownloadRepository repository})
      : _repository = repository {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 30),
      followRedirects: true,
      maxRedirects: 5,
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        AppLogger.error('Dio error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  Future<String> get downloadDirectory async {
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/$_downloadSubDir');
    } else {
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory(p.join(docs.path, 'Downloads'));
    }
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir.path;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 001: HEAD validation with content-length and MIME detection
  // ────────────────────────────────────────────────────────────────────────────
  Future<UrlValidationResult> validateUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        return UrlValidationResult(valid: false, error: 'Invalid URL format');
      }
      if (!['http', 'https'].contains(uri.scheme.toLowerCase())) {
        return UrlValidationResult(valid: false, error: 'Only HTTP/HTTPS supported');
      }

      final response = await _dio.head(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': '*/*'},
        ),
      );

      final headers = response.headers;
      final contentLength = int.tryParse(headers.value('content-length') ?? '');
      final contentType = headers.value('content-type');
      final acceptRanges = headers.value('accept-ranges');
      final supportsResume = acceptRanges?.toLowerCase() == 'bytes';

      // Extract filename from content-disposition or URL
      final contentDisposition = headers.value('content-disposition');
      String? fileName;
      if (contentDisposition != null && contentDisposition.contains('filename=')) {
        final match = RegExp(r'filename[^;=\n]*=([^;\n]*)').firstMatch(contentDisposition);
        if (match != null) {
          fileName = match.group(1)?.replaceAll('"', '').replaceAll("'", '').trim();
        }
      }
      fileName ??= uri.pathSegments.isNotEmpty
          ? Uri.decodeComponent(uri.pathSegments.last)
          : 'download_${_uuid.v4().substring(0, 8)}';
      if (!fileName.contains('.') && contentType != null) {
        final ext = _extensionFromMime(contentType);
        if (ext != null) fileName += ext;
      }

      // Calculate optimal thread count
      int optimalThreads = 1;
      if (supportsResume && contentLength != null && contentLength > 1024 * 1024) {
        optimalThreads = _calculateOptimalThreads(contentLength);
      }

      return UrlValidationResult(
        valid: true,
        fileName: fileName,
        fileSize: contentLength,
        mimeType: contentType,
        supportsResume: supportsResume,
        suggestedThreads: optimalThreads,
      );
    } on DioException catch (e) {
      // Fallback — try GET request for servers that don't support HEAD
      if (e.response?.statusCode == 405) {
        return _validateWithGet(url);
      }
      return UrlValidationResult(valid: false, error: e.message ?? 'Network error');
    } catch (e) {
      return UrlValidationResult(valid: false, error: e.toString());
    }
  }

  Future<UrlValidationResult> _validateWithGet(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Range': 'bytes=0-0'},
          receiveDataWhenStatusError: false,
        ),
      );
      final headers = response.headers;
      final contentLength = int.tryParse(
          headers.value('content-range')?.split('/').last ?? headers.value('content-length') ?? '');
      return UrlValidationResult(
        valid: true,
        fileSize: contentLength,
        mimeType: headers.value('content-type'),
        supportsResume: headers.value('accept-ranges') == 'bytes',
      );
    } catch (e) {
      return UrlValidationResult(valid: false, error: 'Cannot validate URL');
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 003: Multi-thread download engine
  // ────────────────────────────────────────────────────────────────────────────
  Future<String?> startDownload({
    required String url,
    required String fileName,
    int? threadCount,
    int priority = 0,
    String? resumeMetadataJson,
  }) async {
    try {
      final taskId = _uuid.v4();
      final savePath = await downloadDirectory;

      // Validate first
      final validation = await validateUrl(url);
      final threads = threadCount ?? validation.suggestedThreads ?? 1;

      final task = DownloadTask(
        taskId: taskId,
        url: url,
        fileName: fileName,
        savePath: savePath,
        threadCount: threads,
        priority: priority,
        status: DownloadStatus.enqueued,
        supportsResume: validation.supportsResume,
        createdAt: DateTime.now(),
      );

      _tasks[taskId] = task;

      // Persist to DB
      final entity = _taskToEntity(task);
      await _repository.insert(entity);

      // Start download
      _downloadAsync(task, validation.fileSize ?? 0);

      return taskId;
    } catch (e, st) {
      AppLogger.error('Failed to start download', error: e, stackTrace: st);
      return null;
    }
  }

  void _downloadAsync(DownloadTask task, int totalBytes) async {
    try {
      task.totalBytes = totalBytes;
      task.status = DownloadStatus.running;
      _notifyProgress(task);

      if (task.supportsResume && totalBytes > 1024 * 1024 && task.threadCount > 1) {
        await _multiThreadDownload(task, totalBytes);
      } else {
        await _singleThreadDownload(task);
      }
    } catch (e, st) {
      AppLogger.error('Download error for ${task.taskId}', error: e, stackTrace: st);
      task.status = DownloadStatus.failed;
      task.errorMessage = e.toString();
      _notifyProgress(task);
      await _repository.updateStatus(task.taskId, DownloadStatus.failed.index);
    }
  }

  // ── Single-thread download ──────────────────────────────────────────────────
  Future<void> _singleThreadDownload(DownloadTask task) async {
    final destPath = p.join(task.savePath, task.fileName);
    final tempPath = '$destPath.tmp';
    final cancelToken = CancelToken();
    task.cancelToken = cancelToken;

    int lastBytes = 0;
    DateTime lastSpeedCheck = DateTime.now();

    await _dio.download(
      task.url,
      tempPath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (cancelToken.isCancelled) return;
        final now = DateTime.now();
        final elapsed = now.difference(lastSpeedCheck).inMilliseconds;
        if (elapsed > 500) {
          final bytesDiff = received - lastBytes;
          task.speed = bytesDiff / (elapsed / 1000);
          lastBytes = received;
          lastSpeedCheck = now;
        }
        task.downloadedBytes = received;
        task.totalBytes = total > 0 ? total : task.totalBytes;
        task.progress = task.totalBytes > 0 ? received / task.totalBytes : 0;
        task.eta = task.speed > 0
            ? ((task.totalBytes - received) / task.speed).round()
            : 0;
        _notifyProgress(task);
      },
    );

    // Move temp to final
    await File(tempPath).rename(destPath);
    task.status = DownloadStatus.complete;
    task.progress = 1.0;
    task.completedAt = DateTime.now();
    _notifyProgress(task);
    await _repository.updateStatus(task.taskId, DownloadStatus.complete.index);
  }

  // ── Multi-thread download ───────────────────────────────────────────────────
  Future<void> _multiThreadDownload(DownloadTask task, int totalBytes) async {
    final destPath = p.join(task.savePath, task.fileName);
    final tempDir = Directory('${destPath}_parts');
    await tempDir.create(recursive: true);

    // Create or restore segments
    if (task.segments.isEmpty) {
      task.segments = _createSegments(totalBytes, task.threadCount);
    }

    // Save resume metadata
    await _saveResumeMetadata(task);

    final cancelTokens = <CancelToken>[];
    _cancelTokens[task.taskId] = cancelTokens;

    try {
      // Download segments in parallel
      final futures = task.segments
          .where((s) => !s.completed)
          .map((segment) => _downloadSegment(
                task: task,
                segment: segment,
                tempDir: tempDir,
                cancelTokens: cancelTokens,
              ));

      await Future.wait(futures, eagerError: false);

      // Check all segments completed
      final allDone = task.segments.every((s) => s.completed);
      if (!allDone) {
        final failed = task.segments.where((s) => s.error != null).toList();
        throw Exception('${failed.length} segments failed');
      }

      // Merge segments
      await _mergeSegments(task.segments, tempDir, destPath);

      // Cleanup
      await tempDir.delete(recursive: true);

      task.status = DownloadStatus.complete;
      task.progress = 1.0;
      task.completedAt = DateTime.now();
      _notifyProgress(task);
      await _repository.updateStatus(task.taskId, DownloadStatus.complete.index);
    } catch (e) {
      // Save progress for resume
      await _saveResumeMetadata(task);
      rethrow;
    }
  }

  List<SegmentState> _createSegments(int totalBytes, int threadCount) {
    final segmentSize = (totalBytes / threadCount).ceil();
    return List.generate(threadCount, (i) {
      final start = i * segmentSize;
      final end = math.min(start + segmentSize - 1, totalBytes - 1);
      return SegmentState(index: i, startByte: start, endByte: end);
    });
  }

  Future<void> _downloadSegment({
    required DownloadTask task,
    required SegmentState segment,
    required Directory tempDir,
    required List<CancelToken> cancelTokens,
  }) async {
    final cancelToken = CancelToken();
    cancelTokens.add(cancelToken);
    final partPath = p.join(tempDir.path, 'part_${segment.index}');
    final partFile = File(partPath);

    // Retry logic — up to 3 retries per segment
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final startByte = segment.currentByte;
        final endByte = segment.endByte;

        final response = await _dio.get<ResponseBody>(
          task.url,
          options: Options(
            responseType: ResponseType.stream,
            headers: {'Range': 'bytes=$startByte-$endByte'},
          ),
          cancelToken: cancelToken,
        );

        final sink = partFile.openWrite(
            mode: partFile.existsSync() ? FileMode.append : FileMode.write);
        await for (final chunk in response.data!.stream) {
          if (cancelToken.isCancelled) break;
          sink.add(chunk);
          segment.downloadedBytes += chunk.length;

          // Update overall progress
          final totalDownloaded = task.segments.fold(0, (s, seg) => s + seg.downloadedBytes);
          task.downloadedBytes = totalDownloaded;
          task.progress = task.totalBytes > 0 ? totalDownloaded / task.totalBytes : 0;
          _notifyProgress(task);
        }
        await sink.close();

        segment.completed = true;
        segment.error = null;
        return;
      } on DioException catch (e) {
        if (cancelToken.isCancelled) return;
        segment.error = e.message;
        if (attempt < 2) {
          await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        }
      }
    }
  }

  Future<void> _mergeSegments(
      List<SegmentState> segments, Directory tempDir, String destPath) async {
    final sortedSegments = [...segments]..sort((a, b) => a.index.compareTo(b.index));
    final sink = File(destPath).openWrite();

    for (final segment in sortedSegments) {
      final partPath = p.join(tempDir.path, 'part_${segment.index}');
      final partFile = File(partPath);
      if (partFile.existsSync()) {
        await sink.addStream(partFile.openRead());
      }
    }
    await sink.close();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 002: Pause / Resume / Cancel / Retry
  // ────────────────────────────────────────────────────────────────────────────
  Future<void> pauseDownload(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) return;
    // Cancel HTTP requests
    _cancelTokens[taskId]?.forEach((ct) => ct.cancel('Paused'));
    task.cancelToken?.cancel('Paused');
    task.status = DownloadStatus.paused;
    await _saveResumeMetadata(task);
    await _repository.updateStatus(taskId, DownloadStatus.paused.index);
    _notifyProgress(task);
  }

  Future<void> resumeDownload(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) {
      // Try loading from DB
      await _resumeFromDb(taskId);
      return;
    }
    task.status = DownloadStatus.enqueued;
    _downloadAsync(task, task.totalBytes);
  }

  Future<void> _resumeFromDb(String taskId) async {
    try {
      final entity = await _repository.getByTaskId(taskId);
      if (entity == null) return;
      final segments = entity.resumeMetadata != null
          ? (jsonDecode(entity.resumeMetadata!) as List)
              .map((j) => SegmentState.fromJson(j as Map<String, dynamic>))
              .toList()
          : <SegmentState>[];

      final task = DownloadTask(
        taskId: entity.taskId,
        url: entity.url,
        fileName: entity.fileName,
        savePath: entity.savePath,
        threadCount: entity.threadCount,
        priority: entity.priority,
        status: DownloadStatus.enqueued,
        totalBytes: entity.totalBytes,
        downloadedBytes: entity.downloadedBytes,
        supportsResume: entity.supportsResume,
        segments: segments,
        createdAt: entity.createdAt,
      );
      _tasks[taskId] = task;
      _downloadAsync(task, entity.totalBytes);
    } catch (e) {
      AppLogger.error('Resume from DB failed', error: e);
    }
  }

  Future<void> cancelDownload(String taskId) async {
    _cancelTokens[taskId]?.forEach((ct) => ct.cancel('Cancelled'));
    _tasks[taskId]?.cancelToken?.cancel('Cancelled');
    _tasks[taskId]?.status = DownloadStatus.canceled;
    await _repository.updateStatus(taskId, DownloadStatus.canceled.index);
    _tasks.remove(taskId);
    _cancelTokens.remove(taskId);
  }

  Future<void> retryDownload(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) return;
    task.status = DownloadStatus.enqueued;
    task.errorMessage = null;
    task.progress = 0;
    task.downloadedBytes = 0;
    task.segments = [];
    _downloadAsync(task, task.totalBytes);
  }

  Future<void> deleteDownload(String taskId, {bool deleteFile = false}) async {
    cancelDownload(taskId);
    if (deleteFile) {
      final task = _tasks[taskId];
      if (task != null) {
        final filePath = p.join(task.savePath, task.fileName);
        final file = File(filePath);
        if (file.existsSync()) file.deleteSync();
      }
    }
    await _repository.delete(taskId);
    _tasks.remove(taskId);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 006: File integrity checking
  // ────────────────────────────────────────────────────────────────────────────
  Future<FileIntegrityResult> verifyFileIntegrity(
      String filePath, String expectedChecksum, String type) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return FileIntegrityResult(valid: false, error: 'File not found');
      }
      final bytes = await file.readAsBytes();
      String computed;
      switch (type.toLowerCase()) {
        case 'md5':
          computed = md5.convert(bytes).toString();
          break;
        case 'sha1':
          computed = sha1.convert(bytes).toString();
          break;
        case 'sha256':
          computed = sha256.convert(bytes).toString();
          break;
        default:
          return FileIntegrityResult(valid: false, error: 'Unknown checksum type');
      }
      final valid = computed.toLowerCase() == expectedChecksum.toLowerCase();
      return FileIntegrityResult(valid: valid, computed: computed, expected: expectedChecksum);
    } catch (e) {
      return FileIntegrityResult(valid: false, error: e.toString());
    }
  }

  Future<String> computeChecksum(String filePath, {String type = 'sha256'}) async {
    final bytes = await File(filePath).readAsBytes();
    switch (type.toLowerCase()) {
      case 'md5':
        return md5.convert(bytes).toString();
      case 'sha1':
        return sha1.convert(bytes).toString();
      default:
        return sha256.convert(bytes).toString();
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 007: Duplicate detection
  // ────────────────────────────────────────────────────────────────────────────
  Future<DuplicateCheckResult> checkDuplicate(
      String fileName, String savePath) async {
    final fullPath = p.join(savePath, fileName);
    if (!File(fullPath).existsSync()) {
      return DuplicateCheckResult(isDuplicate: false, resolvedPath: fullPath);
    }
    // Generate numbered filename
    final nameWithoutExt = p.basenameWithoutExtension(fileName);
    final ext = p.extension(fileName);
    for (int i = 1; i <= 999; i++) {
      final newPath = p.join(savePath, '$nameWithoutExt ($i)$ext');
      if (!File(newPath).existsSync()) {
        return DuplicateCheckResult(
            isDuplicate: true,
            resolvedPath: newPath,
            resolution: 'renamed_to_$nameWithoutExt ($i)$ext');
      }
    }
    return DuplicateCheckResult(isDuplicate: true, resolvedPath: fullPath);
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Issue 001: Local file save  
  // ────────────────────────────────────────────────────────────────────────────
  Future<String?> saveLocalFile({
    required String sourcePath,
    String? customFileName,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) return null;
      final destDir = await downloadDirectory;
      final originalName = customFileName ?? p.basename(sourcePath);
      final dupCheck = await checkDuplicate(originalName, destDir);
      await sourceFile.copy(dupCheck.resolvedPath);
      return dupCheck.resolvedPath;
    } catch (e) {
      AppLogger.error('saveLocalFile failed', error: e);
      return null;
    }
  }

  Future<bool> isAlreadySaved(String sourcePath) async {
    final destDir = await downloadDirectory;
    return File(p.join(destDir, p.basename(sourcePath))).existsSync();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Helper methods
  // ────────────────────────────────────────────────────────────────────────────
  void _notifyProgress(DownloadTask task) {
    onProgress?.call(
        task.taskId, task.status, task.progress, task.speed, task.eta);
  }

  int _calculateOptimalThreads(int fileSize) {
    if (fileSize < 5 * 1024 * 1024) return 2;
    if (fileSize < 50 * 1024 * 1024) return 4;
    if (fileSize < 200 * 1024 * 1024) return 8;
    return _maxAutoThreads;
  }

  String? _extensionFromMime(String mimeType) {
    final clean = mimeType.split(';').first.trim().toLowerCase();
    const map = {
      'video/mp4': '.mp4',
      'video/webm': '.webm',
      'video/x-matroska': '.mkv',
      'audio/mpeg': '.mp3',
      'audio/aac': '.aac',
      'audio/flac': '.flac',
      'audio/ogg': '.ogg',
      'audio/mp4': '.m4a',
      'application/pdf': '.pdf',
      'application/zip': '.zip',
      'application/x-rar-compressed': '.rar',
      'application/vnd.android.package-archive': '.apk',
      'image/jpeg': '.jpg',
      'image/png': '.png',
      'image/gif': '.gif',
      'image/webp': '.webp',
    };
    return map[clean];
  }

  Future<void> _saveResumeMetadata(DownloadTask task) async {
    if (task.segments.isEmpty) return;
    final metadata = jsonEncode(task.segments.map((s) => s.toJson()).toList());
    await _repository.updateResumeMetadata(task.taskId, metadata);
  }

  DownloadEntity _taskToEntity(DownloadTask task) {
    return DownloadEntity()
      ..taskId = task.taskId
      ..url = task.url
      ..fileName = task.fileName
      ..savePath = task.savePath
      ..status = task.status.index
      ..progress = task.progress
      ..totalBytes = task.totalBytes
      ..downloadedBytes = task.downloadedBytes
      ..speed = task.speed
      ..eta = task.eta
      ..threadCount = task.threadCount
      ..priority = task.priority
      ..supportsResume = task.supportsResume
      ..isBackground = true
      ..createdAt = task.createdAt;
  }

  Future<List<DownloadModel>> getAllDownloads() => _repository.getAll();

  Map<String, DownloadTask> get activeTasks => Map.unmodifiable(_tasks);

  void dispose() {
    for (final tokens in _cancelTokens.values) {
      for (final ct in tokens) {
        ct.cancel('Service disposed');
      }
    }
    _cancelTokens.clear();
    _tasks.clear();
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Result types
// ────────────────────────────────────────────────────────────────────────────
class UrlValidationResult {
  final bool valid;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final bool supportsResume;
  final int? suggestedThreads;
  final String? error;

  UrlValidationResult({
    required this.valid,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.supportsResume = false,
    this.suggestedThreads,
    this.error,
  });
}

class FileIntegrityResult {
  final bool valid;
  final String? computed;
  final String? expected;
  final String? error;

  FileIntegrityResult({required this.valid, this.computed, this.expected, this.error});
}

class DuplicateCheckResult {
  final bool isDuplicate;
  final String resolvedPath;
  final String? resolution;

  DuplicateCheckResult({required this.isDuplicate, required this.resolvedPath, this.resolution});
}
