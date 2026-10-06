// lib/screens/templates/template_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/data/templates/work_templates.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/screens/edit_rule/edit_rule_screen.dart';
import 'package:carlog/screens/mark_done/mark_done_screen.dart';
import 'package:carlog/services/history_service.dart';
import 'package:carlog/utils/formatting.dart';

enum TemplatePickerMode {
  /// Из регламента: тап по работе → создать правило.
  rules,

  /// Из истории: тап по работе → добавить запись в историю.
  history,
}

class TemplatePickerScreen extends StatelessWidget {
  const TemplatePickerScreen({super.key, required this.mode});

  final TemplatePickerMode mode;

  static const _historyService = HistoryService();

  Future<void> _onPickTemplate(
    BuildContext context,
    WorkTemplate template,
  ) async {
    switch (mode) {
      case TemplatePickerMode.rules:
        await _openEditRule(context, template);
      case TemplatePickerMode.history:
        await _openMarkDone(context, title: template.title);
    }
  }

  Future<void> _onCustom(BuildContext context) async {
    switch (mode) {
      case TemplatePickerMode.rules:
        await _openEditRule(context, null);
      case TemplatePickerMode.history:
        await _openMarkDone(context, title: null);
    }
  }

  // --- Регламент ---

  Future<void> _openEditRule(
    BuildContext context,
    WorkTemplate? template,
  ) async {
    final draft = template == null
        ? null
        : Rule(
            title: template.title,
            intervalKm: template.intervalKm,
            intervalMonths: template.intervalMonths,
          );

    final result = await showEditRuleScreen(context, rule: draft);
    if (result == null) return;
    if (!context.mounted) return;

    await context.read<RulesProvider>().add(result);
    if (!context.mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // --- История ---

  Future<void> _openMarkDone(
    BuildContext context, {
    required String? title,
  }) async {
    final result = await showMarkDoneScreen(context, initialTitle: title);
    if (result == null) return;
    if (!context.mounted) return;

    await _historyService.applyManualHistoryAdd(
      result: result,
      history: context.read<HistoryProvider>(),
    );
    if (!context.mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Типовые работы'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _CustomTile(onTap: () => _onCustom(context)),
          const SizedBox(height: 8),
          for (final category in workTemplates) ...[
            _CategoryHeader(name: category.name),
            for (final item in category.items)
              _TemplateTile(
                template: item,
                onTap: () => _onPickTemplate(context, item),
              ),
          ],
        ],
      ),
    );
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.edit_outlined,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Своё'),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        name,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.template,
    required this.onTap,
  });

  final WorkTemplate template;
  final VoidCallback onTap;

  /// «каждые 10 000 км · 12 мес» или «каждые 30 000 км».
  String _intervalLabel() {
    final km = template.intervalKm;
    final months = template.intervalMonths;

    final parts = <String>[];
    if (km != null && km > 0) {
      parts.add('${formatThousands(km)} км');
    }
    if (months != null && months > 0) {
      parts.add('$months мес');
    }
    if (parts.isEmpty) return 'интервал не задан';
    return 'каждые ${parts.join(' · ')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: theme.textTheme.bodyLarge,
                  ),
                  if (template.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      template.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    _intervalLabel(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
