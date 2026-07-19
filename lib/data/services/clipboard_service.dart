import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clipboardServiceProvider = Provider<ClipboardService>((ref) {
  final service = ClipboardService();
  ref.onDispose(service.dispose);
  return service;
});

/// Issue 014 — Clipboard Detection
/// Monitors clipboard for URLs and notifies listeners
class ClipboardService {
  Timer? _timer;
  String? _lastClipboard;
  final _controller = StreamController<String>.broadcast();

  Stream<String> get urlStream => _controller.stream;

  static const _pollInterval = Duration(seconds: 2);

  /// URL patterns to detect
  static final _urlPattern = RegExp(
    'https?://[^\\s"\'<>]+',
    caseSensitive: false,
  );

  /// Supported download sites/platforms
  static final _supportedSites = [
    'youtube.com', 'youtu.be',
    'instagram.com', 'instagr.am',
    'tiktok.com', 'vm.tiktok.com',
    'twitter.com', 'x.com', 't.co',
    'facebook.com', 'fb.com', 'fb.watch',
    'reddit.com', 'redd.it',
    'vimeo.com',
    'dailymotion.com',
    'twitch.tv',
    'soundcloud.com',
    'spotify.com',
  ];

  void startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) => _checkClipboard());
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkClipboard() async {
    try {
      final data = await Clipboard.getData('text/plain');
      final text = data?.text;
      if (text == null || text.isEmpty || text == _lastClipboard) return;
      _lastClipboard = text;
      if (_isValidDownloadUrl(text)) {
        _controller.add(text);
      }
    } catch (_) {}
  }

  bool _isValidDownloadUrl(String text) {
    final trimmed = text.trim();
    if (!_urlPattern.hasMatch(trimmed)) return false;
    
    // Check for direct download file extensions
    final lower = trimmed.toLowerCase();
    const downloadExtensions = [
      '.mp4', '.mkv', '.avi', '.mov', '.webm', '.flv',
      '.mp3', '.aac', '.flac', '.wav', '.ogg', '.m4a', '.opus',
      '.pdf', '.zip', '.rar', '.7z', '.apk',
      '.jpg', '.jpeg', '.png', '.gif', '.webp',
      '.ts', '.m3u8', '.mpd',
    ];
    if (downloadExtensions.any((ext) => lower.contains(ext))) return true;

    // Check for supported sites
    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      final host = uri.host.toLowerCase();
      return _supportedSites.any((site) => host.contains(site));
    }
    return false;
  }

  Future<String?> getCurrentUrl() async {
    try {
      final data = await Clipboard.getData('text/plain');
      final text = data?.text?.trim();
      if (text != null && _isValidDownloadUrl(text)) return text;
    } catch (_) {}
    return null;
  }

  bool isSupportedSite(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return _supportedSites.any((site) => host.contains(site));
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
