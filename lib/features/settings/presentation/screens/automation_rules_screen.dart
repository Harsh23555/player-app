import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/automation_service.dart';
import '../../../../shared/widgets/common_widgets.dart';

final _automationProvider = FutureProvider<List<AutomationRule>>((ref) async {
  final service = ref.watch(automationServiceProvider);
  await service.load();
  return service.rules;
});

/// Issue 028 — Automation Rules Screen
class AutomationRulesScreen extends ConsumerWidget {
  const AutomationRulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(_automationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Automation Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            tooltip: 'Clean Temp Files',
            onPressed: () => _runCleanup(context, ref),
          ),
        ],
      ),
      body: rulesAsync.when(
        data: (rules) => _buildBody(context, ref, rules),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, List<AutomationRule> rules) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: rules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) =>
          _RuleTile(rule: rules[i], index: i, ref: ref),
    );
  }

  Future<void> _runCleanup(BuildContext context, WidgetRef ref) async {
    final service = ref.read(automationServiceProvider);
    final deleted = await service.cleanTempFiles();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cleaned $deleted temp files'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}

class _RuleTile extends ConsumerWidget {
  final AutomationRule rule;
  final int index;
  final WidgetRef ref;

  const _RuleTile({required this.rule, required this.index, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _ruleColor(rule.type).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_ruleIcon(rule.type),
              color: _ruleColor(rule.type), size: 20),
        ),
        title: Text(
          rule.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          rule.description,
          style: TextStyle(
              color: AppTheme.darkTextMuted, fontSize: 12),
        ),
        trailing: Switch(
          value: rule.isEnabled,
          onChanged: (v) async {
            final service = ref.read(automationServiceProvider);
            await service.toggleRule(rule.id, v);
            ref.invalidate(_automationProvider);
          },
          activeColor: AppTheme.primaryViolet,
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 40))
        .fadeIn()
        .slideX(begin: 0.05);
  }

  Color _ruleColor(AutomationRuleType type) {
    switch (type) {
      case AutomationRuleType.autoCategory:
        return AppTheme.primaryViolet;
      case AutomationRuleType.autoRename:
        return AppTheme.accentCyan;
      case AutomationRuleType.smartRetry:
        return Colors.green;
      case AutomationRuleType.duplicateRule:
        return AppTheme.accentGold;
      case AutomationRuleType.cacheCleanup:
      case AutomationRuleType.tempCleanup:
        return AppTheme.accentPink;
    }
  }

  IconData _ruleIcon(AutomationRuleType type) {
    switch (type) {
      case AutomationRuleType.autoCategory:
        return Icons.category_rounded;
      case AutomationRuleType.autoRename:
        return Icons.drive_file_rename_outline_rounded;
      case AutomationRuleType.smartRetry:
        return Icons.replay_rounded;
      case AutomationRuleType.duplicateRule:
        return Icons.copy_all_rounded;
      case AutomationRuleType.cacheCleanup:
        return Icons.cached_rounded;
      case AutomationRuleType.tempCleanup:
        return Icons.cleaning_services_rounded;
    }
  }
}
