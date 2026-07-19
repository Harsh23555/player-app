import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_logger.dart';

final shareIntentServiceProvider = Provider<ShareIntentService>((ref) {
  return ShareIntentService(ref);
});

final sharedUrlProvider = StateProvider<String?>((ref) => null);

/// Issue 015 — Share To Download Service
/// Listens to Android share intent MethodChannel for text/plain URLs
/// and updates the sharedUrlProvider.
class ShareIntentService {
  final Ref _ref;
  static const _channel = MethodChannel('com.novaplayer.app/share');

  ShareIntentService(this._ref);

  void initialize() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onNewShareIntent':
          final rawUrl = call.arguments as String?;
          _handleSharedUrl(rawUrl);
          break;
        default:
          AppLogger.warning('ShareIntentService: Unknown method: ${call.method}');
          break;
      }
    });

    // Check for any initial URL shared when app launched
    checkForInitialShare();
  }

  Future<void> checkForInitialShare() async {
    try {
      final initialUrl = await _channel.invokeMethod<String>('getSharedUrl');
      if (initialUrl != null) {
        _handleSharedUrl(initialUrl);
      }
    } catch (e) {
      AppLogger.error('ShareIntentService: checkForInitialShare failed', error: e);
    }
  }

  void _handleSharedUrl(String? raw) {
    if (raw == null || raw.isEmpty) return;

    // Filter/extract URL from description/text if shared from YouTube, Twitter etc.
    final extracted = _extractUrl(raw);
    if (extracted != null) {
      AppLogger.info('ShareIntentService: Captured shared URL: $extracted');
      _ref.read(sharedUrlProvider.notifier).state = extracted;
    }
  }

  String? _extractUrl(String text) {
    final pattern = RegExp(
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|lon?:[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,})',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(text);
    return match?.group(0);
  }
}
