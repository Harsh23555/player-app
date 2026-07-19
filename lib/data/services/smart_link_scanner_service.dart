import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/app_logger.dart';

final smartLinkScannerProvider = Provider<SmartLinkScannerService>((ref) {
  return SmartLinkScannerService();
});

/// Issue 018 — Smart Link Scanner
/// Parses a webpage and detects downloadable files:
/// images, videos, PDFs, ZIPs, audio, APKs, documents.
class SmartLinkScannerService {
  final _dio = Dio();

  static const _videoExts = [
    'mp4', 'mkv', 'avi', 'mov', 'webm', 'flv', '3gp', 'ts', 'm3u8', 'mpd'
  ];
  static const _audioExts = [
    'mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'opus'
  ];
  static const _imageExts = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'
  ];
  static const _docExts = [
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'epub'
  ];
  static const _archiveExts = ['zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'iso'];
  static const _appExts = ['apk', 'ipa', 'exe', 'dmg'];

  Future<SmartScanResult> scanPage(String url) async {
    try {
      final response = await _dio.get<String>(
        url,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Android; Mobile) AppleWebKit/537.36 Nova/1.0',
            'Accept': 'text/html,*/*',
          },
        ),
      );

      final html = response.data ?? '';
      final baseUri = Uri.tryParse(url);
      final links = _extractLinks(html, baseUri);
      final categorized = _categorize(links);

      return SmartScanResult(
        pageUrl: url,
        allLinks: links,
        videos: categorized['video'] ?? [],
        audios: categorized['audio'] ?? [],
        images: categorized['image'] ?? [],
        documents: categorized['document'] ?? [],
        archives: categorized['archive'] ?? [],
        apps: categorized['app'] ?? [],
        other: categorized['other'] ?? [],
      );
    } catch (e) {
      AppLogger.error('SmartLinkScanner: scanPage failed', error: e);
      return SmartScanResult(
        pageUrl: url,
        error: e.toString(),
        allLinks: [],
        videos: [],
        audios: [],
        images: [],
        documents: [],
        archives: [],
        apps: [],
        other: [],
      );
    }
  }

  List<ScannedLink> _extractLinks(String html, Uri? baseUri) {
    final links = <ScannedLink>[];
    final seen = <String>{};

    // Match src= and href= attributes
    final patterns = [
      RegExp(r'src=["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'href=["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'data-src=["\']([^"\']+)["\']', caseSensitive: false),
      RegExp(r'content=["\']([^"\']+)["\']', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      for (final match in pattern.allMatches(html)) {
        final raw = match.group(1);
        if (raw == null || raw.isEmpty) continue;

        String? resolved;
        final uri = Uri.tryParse(raw);
        if (uri != null && uri.hasScheme) {
          resolved = raw;
        } else if (baseUri != null) {
          try {
            resolved = baseUri.resolve(raw).toString();
          } catch (_) {}
        }

        if (resolved == null || seen.contains(resolved)) continue;
        seen.add(resolved);

        final ext = _extractExtension(resolved);
        if (ext != null && _isInteresting(ext)) {
          links.add(ScannedLink(
            url: resolved,
            extension: ext,
            type: _typeFromExt(ext),
            fileName: p.basename(Uri.tryParse(resolved)?.path ?? resolved),
          ));
        }
      }
    }

    // Also look for HLS/DASH manifests in JavaScript
    final m3u8Pattern = RegExp(r'["\']([^"\']+\.m3u8[^"\']*)["\']');
    final mpdPattern = RegExp(r'["\']([^"\']+\.mpd[^"\']*)["\']');

    for (final match in m3u8Pattern.allMatches(html)) {
      final url = match.group(1);
      if (url != null && !seen.contains(url)) {
        seen.add(url);
        links.add(ScannedLink(
          url: url,
          extension: 'm3u8',
          type: 'video',
          fileName: 'stream.m3u8',
          isStream: true,
        ));
      }
    }

    for (final match in mpdPattern.allMatches(html)) {
      final url = match.group(1);
      if (url != null && !seen.contains(url)) {
        seen.add(url);
        links.add(ScannedLink(
          url: url,
          extension: 'mpd',
          type: 'video',
          fileName: 'stream.mpd',
          isStream: true,
        ));
      }
    }

    return links;
  }

  Map<String, List<ScannedLink>> _categorize(List<ScannedLink> links) {
    final result = <String, List<ScannedLink>>{};
    for (final link in links) {
      result.putIfAbsent(link.type, () => []).add(link);
    }
    return result;
  }

  String? _extractExtension(String url) {
    try {
      final path = Uri.tryParse(url)?.path ?? url;
      final name = p.basename(path);
      final dot = name.lastIndexOf('.');
      if (dot != -1 && dot < name.length - 1) {
        return name.substring(dot + 1).toLowerCase().split('?').first;
      }
    } catch (_) {}
    return null;
  }

  bool _isInteresting(String ext) {
    return [
      ..._videoExts,
      ..._audioExts,
      ..._imageExts,
      ..._docExts,
      ..._archiveExts,
      ..._appExts,
    ].contains(ext);
  }

  String _typeFromExt(String ext) {
    if (_videoExts.contains(ext)) return 'video';
    if (_audioExts.contains(ext)) return 'audio';
    if (_imageExts.contains(ext)) return 'image';
    if (_docExts.contains(ext)) return 'document';
    if (_archiveExts.contains(ext)) return 'archive';
    if (_appExts.contains(ext)) return 'app';
    return 'other';
  }
}

class ScannedLink {
  final String url;
  final String extension;
  final String type;
  final String fileName;
  final bool isStream;

  const ScannedLink({
    required this.url,
    required this.extension,
    required this.type,
    required this.fileName,
    this.isStream = false,
  });
}

class SmartScanResult {
  final String pageUrl;
  final String? error;
  final List<ScannedLink> allLinks;
  final List<ScannedLink> videos;
  final List<ScannedLink> audios;
  final List<ScannedLink> images;
  final List<ScannedLink> documents;
  final List<ScannedLink> archives;
  final List<ScannedLink> apps;
  final List<ScannedLink> other;

  const SmartScanResult({
    required this.pageUrl,
    this.error,
    required this.allLinks,
    required this.videos,
    required this.audios,
    required this.images,
    required this.documents,
    required this.archives,
    required this.apps,
    required this.other,
  });

  bool get hasResults => allLinks.isNotEmpty;
  int get totalCount => allLinks.length;
}
