import 'package:isar/isar.dart';

part 'download_entity.g.dart';

@collection
class DownloadEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String taskId;
  late String url;
  late String fileName;
  late String savePath;
  late int status; // DownloadStatus index
  late double progress;
  late int totalBytes;
  late int downloadedBytes;
  late double speed;
  late int eta;
  String? thumbnailUrl;
  String? errorMessage;
  String? mimeType;
  String? checksum;
  String? checksumType;
  late DateTime createdAt;
  DateTime? completedAt;
  DateTime? scheduledAt;
  late bool isBackground;
  late int priority;
  late int threadCount;
  late bool supportsResume;
  String? resumeMetadata; // JSON of segment states
}

@collection
class DownloadHistoryEntity {
  Id id = Isar.autoIncrement;
  late String url;
  late String fileName;
  late String savePath;
  late int totalBytes;
  late DateTime completedAt;
  String? mimeType;
  String? checksum;
  late int durationMs; // how long download took
}

@collection
class ScheduledDownloadEntity {
  Id id = Isar.autoIncrement;
  late String url;
  late String fileName;
  late DateTime scheduledAt;
  late bool wifiOnly;
  late bool chargingOnly;
  late bool nightModeOnly;
  late int batteryThreshold;
  late bool executed;
}

@collection
class AutomationRuleEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String fileTypePattern; // e.g. "*.mp4", "*.mp3"
  late String targetFolder;
  late bool autoRename;
  late bool autoCategorize;
  late bool isEnabled;
}

@collection
class DownloadAnalyticsEntity {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late int totalDownloads;
  late int successfulDownloads;
  late int failedDownloads;
  late int totalBytes;
  late double averageSpeed;
  late double peakSpeed;
  late int totalDurationMs;
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
