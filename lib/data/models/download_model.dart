import 'package:equatable/equatable.dart';

enum DownloadStatus {
  enqueued,
  running,
  complete,
  failed,
  canceled,
  paused,
  scheduled,
}

class DownloadModel extends Equatable {
  final int id;
  final String taskId;
  final String url;
  final String fileName;
  final String savePath;
  final DownloadStatus status;
  final double progress;
  final int totalBytes;
  final int downloadedBytes;
  final double speed; // bytes/s
  final int eta; // seconds
  final String? thumbnailUrl;
  final String? errorMessage;
  final String? mimeType;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int threadCount;
  final int priority;

  const DownloadModel({
    required this.id,
    required this.taskId,
    required this.url,
    required this.fileName,
    required this.savePath,
    required this.status,
    required this.progress,
    required this.totalBytes,
    required this.downloadedBytes,
    required this.speed,
    required this.eta,
    this.thumbnailUrl,
    this.errorMessage,
    this.mimeType,
    required this.createdAt,
    this.completedAt,
    this.threadCount = 1,
    this.priority = 0,
  });

  String get formattedSpeed {
    if (speed <= 0) return '0 B/s';
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  String get formattedEta {
    if (eta <= 0) return '--';
    if (eta < 60) return '${eta}s';
    if (eta < 3600) return '${(eta / 60).floor()}m ${eta % 60}s';
    return '${(eta / 3600).floor()}h ${((eta % 3600) / 60).floor()}m';
  }

  String get formattedTotalSize {
    if (totalBytes <= 0) return 'Unknown';
    if (totalBytes < 1024 * 1024) return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    if (totalBytes < 1024 * 1024 * 1024) {
      return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get formattedDownloadedSize {
    if (downloadedBytes <= 0) return '0 B';
    if (downloadedBytes < 1024 * 1024) return '${(downloadedBytes / 1024).toStringAsFixed(1)} KB';
    if (downloadedBytes < 1024 * 1024 * 1024) {
      return '${(downloadedBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(downloadedBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get fileExtension {
    final ext = fileName.split('.').last.toLowerCase();
    return ext.isNotEmpty ? ext : 'file';
  }

  String get fileTypeCategory {
    final ext = fileExtension;
    if (['mp4', 'mkv', 'avi', 'mov', 'webm', 'flv', '3gp', 'ts', 'm3u8'].contains(ext)) {
      return 'video';
    }
    if (['mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'opus'].contains(ext)) {
      return 'audio';
    }
    if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'].contains(ext)) {
      return 'document';
    }
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext)) {
      return 'image';
    }
    if (['zip', 'rar', '7z', 'tar', 'gz', 'bz2'].contains(ext)) {
      return 'archive';
    }
    if (ext == 'apk') return 'apk';
    return 'file';
  }

  bool get isActive =>
      status == DownloadStatus.running || status == DownloadStatus.enqueued;
  bool get isPaused => status == DownloadStatus.paused;
  bool get isComplete => status == DownloadStatus.complete;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCanceled => status == DownloadStatus.canceled;
  bool get isScheduled => status == DownloadStatus.scheduled;

  DownloadModel copyWith({
    int? id,
    String? taskId,
    String? url,
    String? fileName,
    String? savePath,
    DownloadStatus? status,
    double? progress,
    int? totalBytes,
    int? downloadedBytes,
    double? speed,
    int? eta,
    String? thumbnailUrl,
    String? errorMessage,
    String? mimeType,
    DateTime? createdAt,
    DateTime? completedAt,
    int? threadCount,
    int? priority,
  }) {
    return DownloadModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      savePath: savePath ?? this.savePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      speed: speed ?? this.speed,
      eta: eta ?? this.eta,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      mimeType: mimeType ?? this.mimeType,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      threadCount: threadCount ?? this.threadCount,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [id, taskId, status, progress, speed, eta];
}
