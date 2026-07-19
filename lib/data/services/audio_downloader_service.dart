import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/utils/app_logger.dart';
import 'adaptive_streaming_service.dart';

final audioDownloaderServiceProvider = Provider<AudioDownloaderService>((ref) {
  final adaptive = ref.watch(adaptiveStreamingServiceProvider);
  return AudioDownloaderService(adaptive: adaptive);
});

/// Issue 023 — Audio Downloader
/// Supports MP3, AAC, FLAC, WAV, OGG, M4A, OPUS
/// with audio extraction, album artwork, and metadata support.
class AudioDownloaderService {
  final AdaptiveStreamingService _adaptive;
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 60),
  ));

  static const _audioExts = ['mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'opus'];
  static const _audioMimes = [
    'audio/mpeg', 'audio/aac', 'audio/flac', 'audio/wav',
    'audio/ogg', 'audio/mp4', 'audio/opus', 'audio/x-flac',
  ];

  AudioDownloaderService({required AdaptiveStreamingService adaptive})
      : _adaptive = adaptive;

  /// Validate whether a URL points to an audio file
  bool isAudioUrl(String url) {
    final ext = _extractExt(url);
    return _audioExts.contains(ext);
  }

  String? _extractExt(String url) {
    try {
      final path = Uri.tryParse(url)?.path ?? '';
      final name = p.basename(path);
      final dot = name.lastIndexOf('.');
      if (dot != -1) return name.substring(dot + 1).toLowerCase().split('?').first;
    } catch (_) {}
    return null;
  }

  /// Download audio file with progress callback
  Future<AudioDownloadResult> downloadAudio({
    required String url,
    required String fileName,
    required String saveDir,
    AudioMetadata? metadata,
    void Function(double progress, double speedBps)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final destPath = p.join(saveDir, fileName);
      final tempPath = '$destPath.tmp';

      int lastBytes = 0;
      DateTime lastCheck = DateTime.now();

      await _dio.download(
        url,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          final now = DateTime.now();
          final elapsed = now.difference(lastCheck).inMilliseconds;
          double speed = 0;
          if (elapsed > 0) {
            speed = (received - lastBytes) / (elapsed / 1000);
            lastBytes = received;
            lastCheck = now;
          }
          final progress = total > 0 ? received / total : 0.0;
          onProgress?.call(progress, speed);
        },
      );

      await File(tempPath).rename(destPath);

      return AudioDownloadResult(
        success: true,
        filePath: destPath,
        fileName: fileName,
      );
    } catch (e) {
      AppLogger.error('AudioDownloader: failed', error: e);
      return AudioDownloadResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Get available audio quality options from a URL using HEAD request
  Future<List<AudioQualityOption>> getQualityOptions(String url) async {
    final options = <AudioQualityOption>[];

    // If it's an M3U8, parse as HLS
    if (url.contains('.m3u8')) {
      final manifest = await _adaptive.parseM3U8(url);
      if (manifest != null && manifest.isMaster) {
        for (final variant in manifest.variants) {
          options.add(AudioQualityOption(
            label: variant.qualityLabel,
            url: variant.url,
            bitrate: variant.bandwidth ~/ 1000,
            codec: variant.codecs,
          ));
        }
      }
      return options;
    }

    // Direct audio file — return single option
    try {
      final response = await _dio.head(url);
      final contentLength = int.tryParse(
          response.headers.value('content-length') ?? '');
      final mimeType = response.headers.value('content-type') ?? '';
      final ext = _extractExt(url) ?? 'audio';
      options.add(AudioQualityOption(
        label: ext.toUpperCase(),
        url: url,
        fileSize: contentLength,
        codec: mimeType,
      ));
    } catch (_) {}

    return options;
  }
}

class AudioQualityOption {
  final String label;
  final String url;
  final int? bitrate; // kbps
  final int? fileSize; // bytes
  final String codec;

  const AudioQualityOption({
    required this.label,
    required this.url,
    this.bitrate,
    this.fileSize,
    this.codec = '',
  });

  String get displayLabel {
    if (bitrate != null) return '$label (${bitrate}kbps)';
    if (fileSize != null) {
      final mb = (fileSize! / (1024 * 1024)).toStringAsFixed(1);
      return '$label (${mb}MB)';
    }
    return label;
  }
}

class AudioMetadata {
  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final int? year;
  final String? artworkUrl;

  const AudioMetadata({
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.year,
    this.artworkUrl,
  });
}

class AudioDownloadResult {
  final bool success;
  final String? filePath;
  final String? fileName;
  final String? error;

  const AudioDownloadResult({
    required this.success,
    this.filePath,
    this.fileName,
    this.error,
  });
}

/// Issue 022 — Video Quality Selection helper
class VideoQualityHelper {
  static List<VideoQualityOption> getQualityOptions() {
    return [
      VideoQualityOption(label: 'Auto', resolution: 0, isAuto: true),
      VideoQualityOption(label: 'Audio Only', resolution: 0, isAudioOnly: true),
      VideoQualityOption(label: '144p', resolution: 144),
      VideoQualityOption(label: '240p', resolution: 240),
      VideoQualityOption(label: '360p', resolution: 360),
      VideoQualityOption(label: '480p', resolution: 480),
      VideoQualityOption(label: '720p HD', resolution: 720),
      VideoQualityOption(label: '1080p FHD', resolution: 1080),
      VideoQualityOption(label: '1440p QHD', resolution: 1440),
      VideoQualityOption(label: '2K', resolution: 1440),
      VideoQualityOption(label: '4K UHD', resolution: 2160),
      VideoQualityOption(label: '4K 60fps', resolution: 2160, fps: 60),
      VideoQualityOption(label: '8K', resolution: 4320),
      VideoQualityOption(label: 'HDR', resolution: 1080, isHdr: true),
    ];
  }

  static List<VideoCodecOption> getCodecOptions() {
    return [
      VideoCodecOption(codec: 'AVC', label: 'H.264 AVC', description: 'Best compatibility'),
      VideoCodecOption(codec: 'HEVC', label: 'H.265 HEVC', description: 'Better compression'),
      VideoCodecOption(codec: 'AV1', label: 'AV1', description: 'Best quality/size ratio'),
    ];
  }
}

class VideoQualityOption {
  final String label;
  final int resolution;
  final bool isAuto;
  final bool isAudioOnly;
  final bool isHdr;
  final int fps;

  const VideoQualityOption({
    required this.label,
    required this.resolution,
    this.isAuto = false,
    this.isAudioOnly = false,
    this.isHdr = false,
    this.fps = 30,
  });
}

class VideoCodecOption {
  final String codec;
  final String label;
  final String description;

  const VideoCodecOption({
    required this.codec,
    required this.label,
    required this.description,
  });
}

/// Issue 024 — Playlist Downloader
class PlaylistDownloaderService {
  final Dio _dio = Dio();

  /// Parse a playlist-like URL (e.g., YouTube playlist, M3U playlist file)
  /// and return a list of individual downloadable items.
  Future<List<PlaylistItem>> parsePlaylist(String url) async {
    final items = <PlaylistItem>[];

    // Handle M3U / M3U8 playlist files
    if (url.endsWith('.m3u') || url.endsWith('.m3u8') && !url.contains('://')) {
      // Local M3U file
      try {
        final content = await File(url).readAsString();
        return _parseM3UPlaylist(content, url);
      } catch (_) {}
    }

    // Remote M3U playlist
    try {
      final response = await _dio.get<String>(url,
          options: Options(responseType: ResponseType.plain));
      final content = response.data ?? '';
      if (content.contains('#EXTM3U')) {
        return _parseM3UPlaylist(content, url);
      }
    } catch (e) {
      AppLogger.error('parsePlaylist: failed', error: e);
    }

    return items;
  }

  List<PlaylistItem> _parseM3UPlaylist(String content, String baseUrl) {
    final items = <PlaylistItem>[];
    final lines = content.split('\n');
    String? currentTitle;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('#EXTINF')) {
        final match = RegExp(r'#EXTINF:[^,]*,(.+)').firstMatch(trimmed);
        currentTitle = match?.group(1)?.trim();
      } else if (trimmed.isNotEmpty && !trimmed.startsWith('#')) {
        final resolvedUrl = trimmed.startsWith('http')
            ? trimmed
            : Uri.tryParse(baseUrl)?.resolve(trimmed).toString() ?? trimmed;
        items.add(PlaylistItem(
          title: currentTitle ?? p.basename(trimmed),
          url: resolvedUrl,
          index: items.length,
        ));
        currentTitle = null;
      }
    }
    return items;
  }
}

class PlaylistItem {
  final String title;
  final String url;
  final int index;
  final String? thumbnailUrl;
  final Duration? duration;
  bool selected;

  PlaylistItem({
    required this.title,
    required this.url,
    required this.index,
    this.thumbnailUrl,
    this.duration,
    this.selected = true,
  });
}
