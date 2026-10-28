// lib/screens/rules/rules_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/confirm_delete_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/screens/edit_rule/edit_rule_screen.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/screens/main/widgets/settings_action.dart';
import 'package:carlog/screens/templates/template_picker_screen.dart';
import 'widgets/rule_card.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  Object? _expandedId;

  /// [canExpand] == false → карточка не может разворачиваться,
  /// экран ничего не делает (открытая карточка остаётся открытой).
  void _toggleExpanded(Rule rule, {required bool canExpand}) {
    if (!canExpand) return;
    setState(() {
      _expandedId = _expandedId == rule.id ? null : rule.id;
    });
  }

  Future<void> _openTemplates() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TemplatePickerScreen(
          mode: TemplatePickerMode.rules,
        ),
      ),
    );
  }

  Future<void> _openEdit(Rule rule) async {
    final result = await showEditRuleScreen(context, rule: rule);
    if (result == null) return;
    if (!mounted) return;

    await context.read<RulesProvider>().update(result);
  }

  Future<void> _confirmDelete(Rule rule) async {
    final l10n = context.l10n;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.rulesDeleteTitle(title: rule.title),
      message: l10n.rulesDeleteMessage,
    );
    if (!confirmed) return;
    if (!mounted) return;

    await context.read<RulesProvider>().remove(rule.id!);
  }

  @override
  Widget build(BuildContext context) {
    final rules = context.watch<RulesProvider>().rules;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPlanning),
        actions: const [SettingsAction()],
      ),
      body: rules.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: rules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rule = rules[index];
                return RuleCard(
                  rule: rule,
                  expanded: rule.id == _expandedId,
                  onToggle: (canExpand) =>
                      _toggleExpanded(rule, canExpand: canExpand),
                  onEdit: () => _openEdit(rule),
                  onDelete: () => _confirmDelete(rule),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_add_rule',
        onPressed: _openTemplates,
        tooltip: l10n.rulesAddTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.build_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.rulesEmptyTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.rulesEmptyMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HelpScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: Text(l10n.rulesHowToStart),
            ),
          ],
        ),
      ),
    );
  }
}
