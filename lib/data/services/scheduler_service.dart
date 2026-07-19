import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/utils/app_logger.dart';

final schedulerServiceProvider = Provider<SchedulerService>((ref) {
  return SchedulerService();
});

/// Issue 012 — Download Scheduler
/// Handles scheduling downloads for later, WiFi-only, charging-only, etc.
class SchedulerService {
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: false,
      );
      _initialized = true;
    } catch (e) {
      AppLogger.error('SchedulerService init failed', error: e);
    }
  }

  /// Schedule a download for a specific time
  Future<bool> scheduleDownload({
    required String taskId,
    required String url,
    required String fileName,
    required DateTime scheduledAt,
    bool wifiOnly = false,
    bool chargingOnly = false,
    bool nightModeOnly = false,
    int batteryThreshold = 0,
  }) async {
    if (!_initialized) await initialize();
    try {
      final delay = scheduledAt.difference(DateTime.now());
      if (delay.isNegative) return false;

      await Workmanager().registerOneOffTask(
        'download_$taskId',
        'scheduleDownload',
        initialDelay: delay,
        constraints: Constraints(
          networkType:
              wifiOnly ? NetworkType.unmetered : NetworkType.connected,
          requiresCharging: chargingOnly,
          requiresBatteryNotLow: batteryThreshold > 0,
        ),
        inputData: {
          'taskId': taskId,
          'url': url,
          'fileName': fileName,
          'batteryThreshold': batteryThreshold,
        },
      );
      return true;
    } catch (e) {
      AppLogger.error('scheduleDownload failed', error: e);
      return false;
    }
  }

  /// Schedule a nightly download window (e.g. 2 AM)
  Future<bool> scheduleNightMode({
    required String taskId,
    required String url,
    required String fileName,
  }) async {
    final now = DateTime.now();
    var nightTime = DateTime(now.year, now.month, now.day, 2, 0, 0);
    if (nightTime.isBefore(now)) {
      nightTime = nightTime.add(const Duration(days: 1));
    }
    return scheduleDownload(
      taskId: taskId,
      url: url,
      fileName: fileName,
      scheduledAt: nightTime,
      wifiOnly: true,
    );
  }

  /// Cancel a scheduled download
  Future<void> cancelScheduled(String taskId) async {
    try {
      await Workmanager().cancelByUniqueName('download_$taskId');
    } catch (e) {
      AppLogger.error('cancelScheduled failed', error: e);
    }
  }

  Future<void> cancelAll() async {
    try {
      await Workmanager().cancelAll();
    } catch (e) {
      AppLogger.error('SchedulerService cancelAll failed', error: e);
    }
  }
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'scheduleDownload') {
      final taskId = inputData?['taskId'] as String?;
      final url = inputData?['url'] as String?;
      final fileName = inputData?['fileName'] as String?;
      AppLogger.info('Workmanager: Executing scheduled download for $taskId: $url -> $fileName');
      // In a real implementation, trigger the download service here
      return Future.value(true);
    }
    return Future.value(false);
  });
}

/// Network constraint mode for display
extension NetworkTypeLabel on NetworkType {
  String get label {
    switch (this) {
      case NetworkType.unmetered:
        return 'Wi-Fi Only';
      case NetworkType.connected:
        return 'Any Network';
      case NetworkType.not_required:
        return 'No Network Required';
      default:
        return 'Unknown';
    }
  }
}
