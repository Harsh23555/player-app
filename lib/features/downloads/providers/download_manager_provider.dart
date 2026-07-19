import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/download_model.dart';
import '../../../data/services/multi_thread_download_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/scheduler_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────
class DownloadManagerState {
  final List<DownloadModel> downloads;
  final bool isLoading;
  final String? error;
  final int maxConcurrent;

  const DownloadManagerState({
    this.downloads = const [],
    this.isLoading = false,
    this.error,
    this.maxConcurrent = 3,
  });

  DownloadManagerState copyWith({
    List<DownloadModel>? downloads,
    bool? isLoading,
    String? error,
    int? maxConcurrent,
  }) =>
      DownloadManagerState(
        downloads: downloads ?? this.downloads,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        maxConcurrent: maxConcurrent ?? this.maxConcurrent,
      );

  // Computed lists
  List<DownloadModel> get active =>
      downloads.where((d) => d.status == DownloadStatus.running).toList();
  List<DownloadModel> get queued =>
      downloads.where((d) => d.status == DownloadStatus.enqueued).toList();
  List<DownloadModel> get paused =>
      downloads.where((d) => d.isPaused).toList();
  List<DownloadModel> get completed =>
      downloads.where((d) => d.isComplete).toList();
  List<DownloadModel> get failed =>
      downloads.where((d) => d.isFailed).toList();
  List<DownloadModel> get scheduled =>
      downloads.where((d) => d.isScheduled).toList();
  List<DownloadModel> get canceled =>
      downloads.where((d) => d.isCanceled).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────
class DownloadManagerNotifier extends StateNotifier<DownloadManagerState> {
  final MultiThreadDownloadService _service;
  final DownloadNotificationService _notifications;
  final SchedulerService _scheduler;

  DownloadManagerNotifier(
    this._service,
    this._notifications,
    this._scheduler,
  ) : super(const DownloadManagerState()) {
    _init();
  }

  void _init() {
    // Listen to progress updates from the download service
    _service.onProgress = (taskId, status, progress, speed, eta) {
      final updated = state.downloads.map((d) {
        if (d.taskId == taskId) {
          final updated = d.copyWith(
            status: status,
            progress: progress,
            speed: speed,
            eta: eta,
            completedAt: status == DownloadStatus.complete ? DateTime.now() : d.completedAt,
          );

          // Show notification updates
          if (status == DownloadStatus.running || status == DownloadStatus.paused) {
            _notifications.showProgress(
              taskId: taskId,
              fileName: d.fileName,
              progress: (progress * 100).round(),
              speed: d.formattedSpeed,
              eta: d.formattedEta,
              status: status,
            );
          } else if (status == DownloadStatus.complete) {
            _notifications.showComplete(
              taskId: taskId,
              fileName: d.fileName,
              fileSize: d.formattedTotalSize,
            );
          } else if (status == DownloadStatus.failed) {
            _notifications.showFailed(
              taskId: taskId,
              fileName: d.fileName,
              error: d.errorMessage ?? 'Unknown error',
            );
          }

          return updated;
        }
        return d;
      }).toList();
      state = state.copyWith(downloads: updated);
    };

    _notifications.initialize();
    _scheduler.initialize();
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    state = state.copyWith(isLoading: true);
    try {
      final downloads = await _service.getAllDownloads();
      state = state.copyWith(downloads: downloads, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Issue 001-003: Start download with thread configuration
  Future<bool> startDownloadWithConfig({
    required String url,
    required String fileName,
    int threadCount = 4,
    int priority = 0,
  }) async {
    final taskId = await _service.startDownload(
      url: url,
      fileName: fileName,
      threadCount: threadCount,
      priority: priority,
    );

    if (taskId == null) {
      state = state.copyWith(error: 'Failed to start download');
      return false;
    }

    await loadDownloads();
    return true;
  }

  /// Issue 012: Schedule a download
  Future<bool> scheduleDownload({
    required String url,
    required String fileName,
    required DateTime scheduledAt,
    bool wifiOnly = false,
    bool chargingOnly = false,
  }) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    return _scheduler.scheduleDownload(
      taskId: taskId,
      url: url,
      fileName: fileName,
      scheduledAt: scheduledAt,
      wifiOnly: wifiOnly,
      chargingOnly: chargingOnly,
    );
  }

  /// Issue 002: Pause download
  Future<void> pauseDownload(String taskId) async {
    await _service.pauseDownload(taskId);
    await loadDownloads();
  }

  /// Issue 002: Resume download
  Future<void> resumeDownload(String taskId) async {
    await _service.resumeDownload(taskId);
    await loadDownloads();
  }

  /// Issue 002: Cancel download
  Future<void> cancelDownload(String taskId) async {
    await _service.cancelDownload(taskId);
    _notifications.cancelNotification(taskId);
    await loadDownloads();
  }

  /// Issue 002: Retry failed download
  Future<void> retryDownload(String taskId) async {
    await _service.retryDownload(taskId);
    await loadDownloads();
  }

  Future<void> deleteDownload(String taskId, {bool deleteFile = false}) async {
    await _service.deleteDownload(taskId, deleteFile: deleteFile);
    _notifications.cancelNotification(taskId);
    await loadDownloads();
  }

  /// Pause all active downloads
  Future<void> pauseAll() async {
    for (final d in state.active) {
      await _service.pauseDownload(d.taskId);
    }
    await loadDownloads();
  }

  /// Resume all paused downloads
  Future<void> resumeAll() async {
    for (final d in state.paused) {
      await _service.resumeDownload(d.taskId);
    }
    await loadDownloads();
  }

  /// Issue 008: Clear download history
  Future<void> clearHistory() async {
    // This would call repository.clearHistory()
    await loadDownloads();
  }

  /// Issue 004: Set max concurrent downloads
  void setMaxConcurrent(int max) {
    state = state.copyWith(maxConcurrent: max);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────
final downloadManagerProvider =
    StateNotifierProvider<DownloadManagerNotifier, DownloadManagerState>((ref) {
  return DownloadManagerNotifier(
    ref.watch(multiThreadDownloadServiceProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(schedulerServiceProvider),
  );
});
