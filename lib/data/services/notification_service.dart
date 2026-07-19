import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/download_model.dart';
import '../../core/utils/app_logger.dart';

final notificationServiceProvider = Provider<DownloadNotificationService>((ref) {
  return DownloadNotificationService();
});

/// Issue 010, 011 — Download Notifications with actions
class DownloadNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channel = AndroidNotificationChannel(
    'nova_downloads',
    'Nova Player Downloads',
    description: 'Download progress notifications',
    importance: Importance.defaultImportance,
    showBadge: true,
    enableVibration: false,
    playSound: false,
  );

  static const _completedChannel = AndroidNotificationChannel(
    'nova_downloads_complete',
    'Nova Player Download Complete',
    description: 'Download completion notifications',
    importance: Importance.high,
    showBadge: true,
    enableVibration: true,
  );

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      // Create channels
      if (Platform.isAndroid) {
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.createNotificationChannel(_channel);
        await androidPlugin?.createNotificationChannel(_completedChannel);
      }

      _initialized = true;
    } catch (e) {
      AppLogger.error('NotificationService init failed', error: e);
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification actions (pause/resume/cancel)
    final payload = response.payload?.split(':');
    if (payload == null || payload.length < 2) return;
    AppLogger.info('Notification action: ${response.actionId} for ${payload[0]}');
    // Actions are handled via MethodChannel callbacks or app routing
  }

  /// Show ongoing download progress notification
  Future<void> showProgress({
    required String taskId,
    required String fileName,
    required int progress,
    required String speed,
    required String eta,
    required DownloadStatus status,
  }) async {
    if (!_initialized) await initialize();
    final notifId = taskId.hashCode.abs() % 100000;

    final actions = <AndroidNotificationAction>[];
    if (status == DownloadStatus.running) {
      actions.add(const AndroidNotificationAction(
        'pause',
        'Pause',
        showsUserInterface: false,
        cancelNotification: false,
      ));
      actions.add(const AndroidNotificationAction(
        'cancel',
        'Cancel',
        showsUserInterface: false,
        cancelNotification: true,
      ));
    } else if (status == DownloadStatus.paused) {
      actions.add(const AndroidNotificationAction(
        'resume',
        'Resume',
        showsUserInterface: false,
        cancelNotification: false,
      ));
      actions.add(const AndroidNotificationAction(
        'cancel',
        'Cancel',
        showsUserInterface: false,
        cancelNotification: true,
      ));
    }

    final styleInformation = status == DownloadStatus.running ||
            status == DownloadStatus.paused
        ? BigTextStyleInformation(
            '$speed • ETA: $eta',
            contentTitle: _truncate(fileName, 40),
          )
        : null;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        progress: progress,
        maxProgress: 100,
        showProgress: true,
        onlyAlertOnce: true,
        ongoing: status == DownloadStatus.running,
        autoCancel: false,
        category: AndroidNotificationCategory.progress,
        styleInformation: styleInformation,
        actions: actions,
        subText: '${progress.toString()}%',
      ),
    );

    try {
      await _plugin.show(
        notifId,
        _truncate(fileName, 40),
        '${_statusLabel(status)} • $speed • ETA: $eta',
        details,
        payload: '$taskId:download',
      );
    } catch (e) {
      AppLogger.error('showProgress failed', error: e);
    }
  }

  /// Show download completed notification
  Future<void> showComplete({
    required String taskId,
    required String fileName,
    required String fileSize,
  }) async {
    if (!_initialized) await initialize();
    final notifId = taskId.hashCode.abs() % 100000;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _completedChannel.id,
        _completedChannel.name,
        channelDescription: _completedChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.status,
        autoCancel: true,
        styleInformation: BigTextStyleInformation(
          'File size: $fileSize\nTap to open',
          contentTitle: 'Download complete!',
        ),
        actions: const [
          AndroidNotificationAction(
            'open',
            'Open',
            showsUserInterface: true,
            cancelNotification: true,
          ),
        ],
      ),
    );

    try {
      await _plugin.show(
        notifId,
        'Download Complete',
        _truncate(fileName, 50),
        details,
        payload: '$taskId:open',
      );
    } catch (e) {
      AppLogger.error('showComplete failed', error: e);
    }
  }

  /// Show download failed notification
  Future<void> showFailed({
    required String taskId,
    required String fileName,
    required String error,
  }) async {
    if (!_initialized) await initialize();
    final notifId = taskId.hashCode.abs() % 100000;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _completedChannel.id,
        _completedChannel.name,
        channelDescription: 'Download notifications',
        importance: Importance.high,
        priority: Priority.high,
        autoCancel: true,
        actions: const [
          AndroidNotificationAction(
            'retry',
            'Retry',
            showsUserInterface: true,
          ),
        ],
      ),
    );

    try {
      await _plugin.show(
        notifId,
        'Download Failed',
        _truncate(fileName, 50),
        details,
        payload: '$taskId:retry',
      );
    } catch (e) {
      AppLogger.error('showFailed failed', error: e);
    }
  }

  Future<void> cancelNotification(String taskId) async {
    try {
      await _plugin.cancel(taskId.hashCode.abs() % 100000);
    } catch (_) {}
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }

  String _statusLabel(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.running:
        return 'Downloading';
      case DownloadStatus.paused:
        return 'Paused';
      case DownloadStatus.enqueued:
        return 'Queued';
      default:
        return 'Downloading';
    }
  }

  String _truncate(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength - 3)}...' : text;
  }

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } catch (e) {
      return false;
    }
  }
}
