import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/utils/app_logger.dart';

final adaptiveStreamingServiceProvider = Provider<AdaptiveStreamingService>((ref) {
  return AdaptiveStreamingService();
});

/// Issue 021 — Adaptive Streaming (HLS / DASH / M3U8 / MPD)
/// Fetches and parses HLS playlists, lists available quality levels,
/// and downloads chosen stream segments.
class AdaptiveStreamingService {
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 30),
  ));

  // ── HLS (M3U8) ────────────────────────────────────────────────────────────
  Future<HlsManifest?> parseM3U8(String url) async {
    try {
      final response = await _dio.get<String>(url,
          options: Options(responseType: ResponseType.plain));
      final content = response.data ?? '';

      if (content.contains('#EXT-X-STREAM-INF')) {
        // Master playlist — extract variant streams
        return _parseMasterM3U8(content, url);
      } else {
        // Media playlist
        final segments = _parseMediaM3U8(content, url);
        return HlsManifest(
          masterUrl: url,
          variants: [],
          segments: segments,
          isMaster: false,
        );
      }
    } catch (e) {
      AppLogger.error('parseM3U8 failed', error: e);
      return null;
    }
  }

  HlsManifest _parseMasterM3U8(String content, String baseUrl) {
    final lines = content.split('\n');
    final variants = <HlsVariant>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('#EXT-X-STREAM-INF')) {
        final attrs = _parseAttrs(line);
        final bandwidth = int.tryParse(attrs['BANDWIDTH'] ?? '0') ?? 0;
        final resolution = attrs['RESOLUTION'] ?? '';
        final codecs = attrs['CODECS'] ?? '';

        // Next non-empty line is the URL
        String? variantUrl;
        for (int j = i + 1; j < lines.length; j++) {
          final candidate = lines[j].trim();
          if (candidate.isNotEmpty && !candidate.startsWith('#')) {
            variantUrl = _resolveUrl(candidate, baseUrl);
            break;
          }
        }

        if (variantUrl != null) {
          variants.add(HlsVariant(
            url: variantUrl,
            bandwidth: bandwidth,
            resolution: resolution,
            codecs: codecs,
            qualityLabel: _qualityFromResolution(resolution, bandwidth),
          ));
        }
      }
    }

    // Sort by bandwidth descending
    variants.sort((a, b) => b.bandwidth.compareTo(a.bandwidth));
    return HlsManifest(masterUrl: baseUrl, variants: variants, segments: [], isMaster: true);
  }

  List<String> _parseMediaM3U8(String content, String baseUrl) {
    final lines = content.split('\n');
    final segments = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty && !trimmed.startsWith('#')) {
        segments.add(_resolveUrl(trimmed, baseUrl));
      }
    }
    return segments;
  }

  /// Download all segments from a media playlist into a single .ts file
  Future<String?> downloadHlsStream({
    required String manifestUrl,
    required String outputPath,
    void Function(double progress, int segIndex, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final manifest = await parseM3U8(manifestUrl);
      if (manifest == null) return null;

      List<String> segments = manifest.segments;
      if (manifest.isMaster && manifest.variants.isNotEmpty) {
        // Pick best quality variant and parse its segments
        final best = manifest.variants.first;
        final mediaManifest = await parseM3U8(best.url);
        segments = mediaManifest?.segments ?? [];
      }

      if (segments.isEmpty) return null;

      final tempDir = Directory('${outputPath}_hls_parts');
      await tempDir.create(recursive: true);

      // Download each segment
      for (int i = 0; i < segments.length; i++) {
        if (cancelToken?.isCancelled == true) break;
        final segUrl = segments[i];
        final segPath = p.join(tempDir.path, 'seg_$i.ts');
        try {
          await _dio.download(segUrl, segPath, cancelToken: cancelToken);
        } catch (e) {
          AppLogger.error('HLS segment $i failed: $e');
        }
        onProgress?.call((i + 1) / segments.length, i, segments.length);
      }

      // Merge all .ts segments into output
      final outputFile = File(outputPath);
      final sink = outputFile.openWrite();
      for (int i = 0; i < segments.length; i++) {
        final segPath = p.join(tempDir.path, 'seg_$i.ts');
        final segFile = File(segPath);
        if (segFile.existsSync()) {
          await sink.addStream(segFile.openRead());
        }
      }
      await sink.close();
      await tempDir.delete(recursive: true);

      return outputPath;
    } catch (e) {
      AppLogger.error('downloadHlsStream failed', error: e);
      return null;
    }
  }

  // ── DASH (MPD) ────────────────────────────────────────────────────────────
  Future<List<DashRepresentation>> parseDash(String mpdUrl) async {
    try {
      final response = await _dio.get<String>(mpdUrl,
          options: Options(responseType: ResponseType.plain));
      final xml = response.data ?? '';
      return _parseMpd(xml, mpdUrl);
    } catch (e) {
      AppLogger.error('parseDash failed', error: e);
      return [];
    }
  }

  List<DashRepresentation> _parseMpd(String xml, String baseUrl) {
    final reps = <DashRepresentation>[];
    final repPattern = RegExp(
        r'<Representation\s([^>]+)>',
        dotAll: true);
    for (final match in repPattern.allMatches(xml)) {
      final attrs = _parseAttrs(match.group(1) ?? '');
      final id = attrs['id'] ?? '';
      final bandwidth = int.tryParse(attrs['bandwidth'] ?? '0') ?? 0;
      final width = int.tryParse(attrs['width'] ?? '0') ?? 0;
      final height = int.tryParse(attrs['height'] ?? '0') ?? 0;
      final codecs = attrs['codecs'] ?? '';
      reps.add(DashRepresentation(
        id: id,
        bandwidth: bandwidth,
        width: width,
        height: height,
        codecs: codecs,
        qualityLabel: '${height}p',
      ));
    }
    reps.sort((a, b) => b.bandwidth.compareTo(a.bandwidth));
    return reps;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Map<String, String> _parseAttrs(String line) {
    final map = <String, String>{};
    final pattern = RegExp(r'([A-Z\-a-z]+)=([^,]+)');
    for (final m in pattern.allMatches(line)) {
      map[m.group(1)!] = m.group(2)!.replaceAll('"', '').trim();
    }
    return map;
  }

  String _resolveUrl(String urlOrPath, String baseUrl) {
    if (urlOrPath.startsWith('http')) return urlOrPath;
    final base = Uri.tryParse(baseUrl);
    if (base == null) return urlOrPath;
    return base.resolve(urlOrPath).toString();
  }

  String _qualityFromResolution(String resolution, int bandwidth) {
    if (resolution.isEmpty) {
      final kbps = bandwidth ~/ 1000;
      return '${kbps}kbps';
    }
    final parts = resolution.split('x');
    if (parts.length == 2) {
      final h = int.tryParse(parts[1]) ?? 0;
      return '${h}p';
    }
    return resolution;
  }
}

class HlsManifest {
  final String masterUrl;
  final List<HlsVariant> variants;
  final List<String> segments;
  final bool isMaster;

  const HlsManifest({
    required this.masterUrl,
    required this.variants,
    required this.segments,
    required this.isMaster,
  });
}

class HlsVariant {
  final String url;
  final int bandwidth;
  final String resolution;
  final String codecs;
  final String qualityLabel;

  const HlsVariant({
    required this.url,
    required this.bandwidth,
    required this.resolution,
    required this.codecs,
    required this.qualityLabel,
  });
}

class DashRepresentation {
  final String id;
  final int bandwidth;
  final int width;
  final int height;
  final String codecs;
  final String qualityLabel;

  const DashRepresentation({
    required this.id,
    required this.bandwidth,
    required this.width,
    required this.height,
    required this.codecs,
    required this.qualityLabel,
  });
}
