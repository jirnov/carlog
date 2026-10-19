// lib/screens/rules/rules_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/confirm_delete_dialog.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/screens/edit_rule/edit_rule_screen.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/screens/main/widgets/settings_action.dart';
import 'package:carlog/screens/templates/template_picker_screen.dart';
import 'widgets/rule_card.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  Future<void> _openTemplates(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TemplatePickerScreen(
          mode: TemplatePickerMode.rules,
        ),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, Rule rule) async {
    final result = await showEditRuleScreen(context, rule: rule);
    if (result == null) return;
    if (!context.mounted) return;

    await context.read<RulesProvider>().update(result);
  }

  Future<void> _confirmDelete(BuildContext context, Rule rule) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: 'Удалить правило «${rule.title}»?',
      message: 'История выполненных работ не изменится.',
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    await context.read<RulesProvider>().remove(rule.id!);
  }

  @override
  Widget build(BuildContext context) {
    final rules = context.watch<RulesProvider>().rules;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Планирование'),
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
                  onTap: () => _openEdit(context, rule),
                  onDelete: () => _confirmDelete(context, rule),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_add_rule',
        onPressed: () => _openTemplates(context),
        tooltip: 'Добавить правило',
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
              'Планов пока нет',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте плановое ТО с интервалом\n'
              'и оно появится в графике работ',
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
              label: const Text('Как это работает?'),
            ),
          ],
        ),
      ),
    );
  }
}
