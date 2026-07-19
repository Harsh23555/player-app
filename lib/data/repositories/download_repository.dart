import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/download_model.dart';
import '../models/db/download_entity.dart';

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository(ref.watch(isarProvider));
});

class DownloadRepository {
  final Isar _isar;
  DownloadRepository(this._isar);

  Future<List<DownloadModel>> getAll() async {
    try {
      final entities = await _isar.downloadEntitys
          .where()
          .sortByCreatedAt()
          .findAll();
      return entities.reversed.map(_toModel).toList();
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getAll failed', error: e, stackTrace: st);
      return [];
    }
  }

  Future<DownloadEntity?> getByTaskId(String taskId) async {
    try {
      return await _isar.downloadEntitys
          .where()
          .taskIdEqualTo(taskId)
          .findFirst();
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getByTaskId failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<DownloadModel?> getModelByTaskId(String taskId) async {
    final entity = await getByTaskId(taskId);
    return entity != null ? _toModel(entity) : null;
  }

  Future<void> insert(DownloadEntity entity) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadEntitys.put(entity);
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.insert failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateProgress({
    required String taskId,
    required int status,
    required double progress,
    int totalBytes = 0,
    int downloadedBytes = 0,
    double speed = 0,
  }) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .findFirst();
        if (entity != null) {
          entity.status = status;
          entity.progress = progress;
          if (totalBytes > 0) entity.totalBytes = totalBytes;
          if (downloadedBytes > 0) entity.downloadedBytes = downloadedBytes;
          entity.speed = speed;
          if (speed > 0 && entity.totalBytes > entity.downloadedBytes) {
            entity.eta = ((entity.totalBytes - entity.downloadedBytes) / speed).toInt();
          }
          if (status == DownloadStatus.complete.index) {
            entity.completedAt = DateTime.now();
          }
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateProgress failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateTaskId(String oldTaskId, String newTaskId, int status) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(oldTaskId)
            .findFirst();
        if (entity != null) {
          entity.taskId = newTaskId;
          entity.status = status;
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateTaskId failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateStatus(String taskId, int status) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .findFirst();
        if (entity != null) {
          entity.status = status;
          if (status == DownloadStatus.complete.index) {
            entity.completedAt = DateTime.now();
          }
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateStatus failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateResumeMetadata(String taskId, String metadata) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .findFirst();
        if (entity != null) {
          entity.resumeMetadata = metadata;
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateResumeMetadata failed', error: e, stackTrace: st);
    }
  }

  Future<void> delete(String taskId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .deleteAll();
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.delete failed', error: e, stackTrace: st);
    }
  }

  Future<List<DownloadModel>> getByStatus(DownloadStatus status) async {
    try {
      final all = await _isar.downloadEntitys.where().findAll();
      return all.where((e) => e.status == status.index).map(_toModel).toList();
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getByStatus failed', error: e, stackTrace: st);
      return [];
    }
  }

  Future<List<DownloadModel>> getCompleted() async {
    return getByStatus(DownloadStatus.complete);
  }

  Future<List<DownloadModel>> searchDownloads(String query) async {
    try {
      final all = await _isar.downloadEntitys.where().findAll();
      final q = query.toLowerCase();
      return all
          .where((e) =>
              e.fileName.toLowerCase().contains(q) ||
              e.url.toLowerCase().contains(q))
          .map(_toModel)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadEntitys
            .where()
            .filter()
            .statusEqualTo(DownloadStatus.complete.index)
            .deleteAll();
      });
    } catch (e) {
      AppLogger.error('clearHistory failed', error: e);
    }
  }

  DownloadModel _toModel(DownloadEntity e) {
    return DownloadModel(
      id: e.id,
      taskId: e.taskId,
      url: e.url,
      fileName: e.fileName,
      savePath: e.savePath,
      status: DownloadStatus.values[e.status.clamp(0, DownloadStatus.values.length - 1)],
      progress: e.progress,
      totalBytes: e.totalBytes,
      downloadedBytes: e.downloadedBytes,
      speed: e.speed,
      eta: e.eta,
      thumbnailUrl: e.thumbnailUrl,
      errorMessage: e.errorMessage,
      mimeType: e.mimeType,
      createdAt: e.createdAt,
      completedAt: e.completedAt,
      threadCount: e.threadCount,
      priority: e.priority,
    );
  }
}
