import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/app_logger.dart';

final automationServiceProvider = Provider<AutomationService>((ref) {
  return AutomationService();
});

/// Issue 028 — Automation Rules
/// Auto categorize, auto rename, smart folders, smart retry,
/// duplicate rules, cache cleanup, temp cleanup.
class AutomationService {
  static const _kRulesJson = 'automation_rules_json';
  List<AutomationRule> _rules = [];
  bool _loaded = false;

  List<AutomationRule> get rules => List.unmodifiable(_rules);

  Future<void> load() async {
    if (_loaded) return;
    try {
      // In production: load from Isar / SharedPreferences
      _rules = _defaultRules();
      _loaded = true;
    } catch (e) {
      AppLogger.error('AutomationService.load failed', error: e);
    }
  }

  List<AutomationRule> _defaultRules() {
    return [
      AutomationRule(
        id: 'auto_video',
        name: 'Auto-categorize Videos',
        description: 'Move video files to /Videos folder',
        type: AutomationRuleType.autoCategory,
        filePattern: '*.mp4,*.mkv,*.avi,*.mov,*.webm',
        targetFolder: 'NovaPlayer/Videos',
        isEnabled: true,
      ),
      AutomationRule(
        id: 'auto_audio',
        name: 'Auto-categorize Audio',
        description: 'Move audio files to /Music folder',
        type: AutomationRuleType.autoCategory,
        filePattern: '*.mp3,*.aac,*.flac,*.m4a,*.ogg',
        targetFolder: 'NovaPlayer/Music',
        isEnabled: true,
      ),
      AutomationRule(
        id: 'auto_docs',
        name: 'Auto-categorize Documents',
        description: 'Move documents to /Documents folder',
        type: AutomationRuleType.autoCategory,
        filePattern: '*.pdf,*.doc,*.docx,*.xls',
        targetFolder: 'NovaPlayer/Documents',
        isEnabled: false,
      ),
      AutomationRule(
        id: 'smart_retry',
        name: 'Smart Retry',
        description: 'Auto-retry failed downloads up to 3 times',
        type: AutomationRuleType.smartRetry,
        retryCount: 3,
        retryDelaySeconds: 30,
        isEnabled: true,
      ),
      AutomationRule(
        id: 'temp_cleanup',
        name: 'Temp File Cleanup',
        description: 'Delete .tmp files older than 24h',
        type: AutomationRuleType.tempCleanup,
        maxAgeHours: 24,
        isEnabled: true,
      ),
      AutomationRule(
        id: 'duplicate_skip',
        name: 'Skip Duplicates',
        description: 'Skip downloading files that already exist',
        type: AutomationRuleType.duplicateRule,
        duplicateAction: DuplicateAction.skip,
        isEnabled: true,
      ),
    ];
  }

  /// Apply auto-categorization rule to a completed download
  Future<String?> applyCategory(String filePath) async {
    await load();
    final ext = p.extension(filePath).toLowerCase().replaceFirst('.', '');

    for (final rule in _rules) {
      if (!rule.isEnabled || rule.type != AutomationRuleType.autoCategory) continue;
      if (_matchesPattern(ext, rule.filePattern)) {
        final targetDir = Directory('/storage/emulated/0/${rule.targetFolder}');
        if (!targetDir.existsSync()) {
          await targetDir.create(recursive: true);
        }
        final destPath = p.join(targetDir.path, p.basename(filePath));
        try {
          await File(filePath).rename(destPath);
          AppLogger.info('AutoCategory: moved ${p.basename(filePath)} to ${rule.targetFolder}');
          return destPath;
        } catch (e) {
          AppLogger.error('AutoCategory: move failed', error: e);
        }
      }
    }
    return null;
  }

  bool _matchesPattern(String ext, String pattern) {
    final patterns = pattern.split(',').map((p) =>
        p.trim().replaceAll('*.', '').toLowerCase());
    return patterns.contains(ext);
  }

  /// Clean temp files in downloads directory older than maxAgeHours
  Future<int> cleanTempFiles({String? downloadsPath, int maxAgeHours = 24}) async {
    int cleaned = 0;
    final dir = Directory(downloadsPath ?? '/storage/emulated/0/NovaPlayer/Downloads');
    if (!dir.existsSync()) return 0;

    final cutoff = DateTime.now().subtract(Duration(hours: maxAgeHours));
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.tmp')) {
        try {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoff)) {
            await entity.delete();
            cleaned++;
          }
        } catch (_) {}
      }
    }
    AppLogger.info('AutomationService: cleaned $cleaned temp files');
    return cleaned;
  }

  /// Get retry count for a file type
  int getRetryCount(String fileName) {
    final rule = _rules.firstWhere(
      (r) => r.isEnabled && r.type == AutomationRuleType.smartRetry,
      orElse: () => AutomationRule(
          id: '', name: '', description: '', type: AutomationRuleType.smartRetry,
          retryCount: 3),
    );
    return rule.retryCount;
  }

  /// Get duplicate action for file resolution
  DuplicateAction getDuplicateAction() {
    final rule = _rules.firstWhere(
      (r) => r.isEnabled && r.type == AutomationRuleType.duplicateRule,
      orElse: () => AutomationRule(
          id: '', name: '', description: '', type: AutomationRuleType.duplicateRule,
          duplicateAction: DuplicateAction.rename),
    );
    return rule.duplicateAction;
  }

  Future<void> toggleRule(String id, bool enabled) async {
    final idx = _rules.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _rules[idx] = _rules[idx].copyWith(isEnabled: enabled);
    }
  }

  Future<void> addRule(AutomationRule rule) async {
    _rules.add(rule);
  }

  Future<void> removeRule(String id) async {
    _rules.removeWhere((r) => r.id == id);
  }
}

enum AutomationRuleType {
  autoCategory,
  autoRename,
  smartRetry,
  duplicateRule,
  cacheCleanup,
  tempCleanup,
}

enum DuplicateAction {
  skip,
  replace,
  rename,
  keepBoth,
}

extension AutomationRuleTypeLabel on AutomationRuleType {
  String get label {
    switch (this) {
      case AutomationRuleType.autoCategory:
        return 'Auto Categorize';
      case AutomationRuleType.autoRename:
        return 'Auto Rename';
      case AutomationRuleType.smartRetry:
        return 'Smart Retry';
      case AutomationRuleType.duplicateRule:
        return 'Duplicate Rule';
      case AutomationRuleType.cacheCleanup:
        return 'Cache Cleanup';
      case AutomationRuleType.tempCleanup:
        return 'Temp Cleanup';
    }
  }
}

class AutomationRule {
  final String id;
  final String name;
  final String description;
  final AutomationRuleType type;
  final String filePattern;
  final String targetFolder;
  final bool isEnabled;
  final int retryCount;
  final int retryDelaySeconds;
  final int maxAgeHours;
  final DuplicateAction duplicateAction;

  const AutomationRule({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.filePattern = '*',
    this.targetFolder = '',
    this.isEnabled = true,
    this.retryCount = 3,
    this.retryDelaySeconds = 30,
    this.maxAgeHours = 24,
    this.duplicateAction = DuplicateAction.rename,
  });

  AutomationRule copyWith({
    String? id,
    String? name,
    String? description,
    AutomationRuleType? type,
    String? filePattern,
    String? targetFolder,
    bool? isEnabled,
    int? retryCount,
    int? retryDelaySeconds,
    int? maxAgeHours,
    DuplicateAction? duplicateAction,
  }) =>
      AutomationRule(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        filePattern: filePattern ?? this.filePattern,
        targetFolder: targetFolder ?? this.targetFolder,
        isEnabled: isEnabled ?? this.isEnabled,
        retryCount: retryCount ?? this.retryCount,
        retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
        maxAgeHours: maxAgeHours ?? this.maxAgeHours,
        duplicateAction: duplicateAction ?? this.duplicateAction,
      );
}
