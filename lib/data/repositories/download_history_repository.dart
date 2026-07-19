import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/db/download_entity.dart';

final downloadHistoryRepositoryProvider =
    Provider<DownloadHistoryRepository>((ref) {
  return DownloadHistoryRepository(ref.watch(isarProvider));
});

/// Issue 008 — Download History Repository
class DownloadHistoryRepository {
  final Isar _isar;

  DownloadHistoryRepository(this._isar);

  Future<void> add({
    required String url,
    required String fileName,
    required String savePath,
    required int totalBytes,
    String? mimeType,
    String? checksum,
    int durationMs = 0,
  }) async {
    try {
      final entity = DownloadHistoryEntity()
        ..url = url
        ..fileName = fileName
        ..savePath = savePath
        ..totalBytes = totalBytes
        ..completedAt = DateTime.now()
        ..mimeType = mimeType
        ..checksum = checksum
        ..durationMs = durationMs;

      await _isar.writeTxn(() async {
        await _isar.downloadHistoryEntitys.put(entity);
      });
      AppLogger.info('DownloadHistory: Added entry for $fileName');
    } catch (e, st) {
      AppLogger.error('DownloadHistoryRepository.add failed',
          error: e, stackTrace: st);
    }
  }

  Future<List<DownloadHistoryEntity>> getAll() async {
    try {
      final results = await _isar.downloadHistoryEntitys
          .where()
          .sortByCompletedAtDesc()
          .findAll();
      return results;
    } catch (e, st) {
      AppLogger.error('DownloadHistoryRepository.getAll failed',
          error: e, stackTrace: st);
      return [];
    }
  }

  Future<List<DownloadHistoryEntity>> search(String query) async {
    try {
      final list = await _isar.downloadHistoryEntitys.where().findAll();
      final q = query.toLowerCase();
      return list
          .where((e) =>
              e.fileName.toLowerCase().contains(q) ||
              e.url.toLowerCase().contains(q))
          .toList();
    } catch (e) {
      AppLogger.error('DownloadHistoryRepository.search failed', error: e);
      return [];
    }
  }

  Future<void> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadHistoryEntitys.delete(id);
      });
    } catch (e) {
      AppLogger.error('DownloadHistoryRepository.delete failed', error: e);
    }
  }

  Future<void> clearAll() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadHistoryEntitys.clear();
      });
    } catch (e) {
      AppLogger.error('DownloadHistoryRepository.clearAll failed', error: e);
    }
  }

  /// Export history as JSON
  Future<String> exportJson() async {
    final list = await getAll();
    final data = list.map((e) => {
      'url': e.url,
      'fileName': e.fileName,
      'savePath': e.savePath,
      'totalBytes': e.totalBytes,
      'completedAt': e.completedAt.toIso8601String(),
      'mimeType': e.mimeType,
      'checksum': e.checksum,
      'durationMs': e.durationMs,
    }).toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Import history from JSON string
  Future<bool> importJson(String jsonStr) async {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        final entities = <DownloadHistoryEntity>[];
        for (final item in decoded) {
          if (item is Map) {
            final entity = DownloadHistoryEntity()
              ..url = item['url'] ?? ''
              ..fileName = item['fileName'] ?? ''
              ..savePath = item['savePath'] ?? ''
              ..totalBytes = item['totalBytes'] ?? 0
              ..completedAt = DateTime.tryParse(item['completedAt'] ?? '') ?? DateTime.now()
              ..mimeType = item['mimeType']
              ..checksum = item['checksum']
              ..durationMs = item['durationMs'] ?? 0;
            entities.add(entity);
          }
        }
        await _isar.writeTxn(() async {
          for (final entity in entities) {
            await _isar.downloadHistoryEntitys.put(entity);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('DownloadHistoryRepository.importJson failed', error: e);
      return false;
    }
  }
}
