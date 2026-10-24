// lib/screens/history/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/dialogs/confirm_delete_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/screens/main/widgets/settings_action.dart';
import 'package:carlog/screens/mark_done/mark_done_screen.dart';
import 'package:carlog/screens/templates/template_picker_screen.dart';
import 'package:carlog/services/history_service.dart';
import 'widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const _historyService = HistoryService();

  Future<void> _openTemplates(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TemplatePickerScreen(
          mode: TemplatePickerMode.history,
        ),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, HistoryRecord record) async {
    final result = await showMarkDoneScreen(context, record: record);
    if (result == null) return;
    if (!context.mounted) return;

    await _historyService.applyHistoryUpdate(
      result: result,
      history: context.read<HistoryProvider>(),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, HistoryRecord record) async {
    final l10n = context.l10n;

    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.historyDeleteTitle(title: record.title),
      message: l10n.historyDeleteMessage,
    );
    if (!confirmed) return;
    if (!context.mounted) return;

    await context.read<HistoryProvider>().remove(record.id!);
  }

  @override
  Widget build(BuildContext context) {
    final records = context.watch<HistoryProvider>().records;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: const [SettingsAction()],
      ),
      body: records.isEmpty
          ? const _EmptyState()
          : _GroupedList(
              records: records,
              onTap: (record) => _openEdit(context, record),
              onDelete: (record) => _confirmDelete(context, record),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_add_history',
        onPressed: () => _openTemplates(context),
        tooltip: l10n.historyAddTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  const _GroupedList({
    required this.records,
    required this.onTap,
    required this.onDelete,
  });

  final List<HistoryRecord> records;
  final void Function(HistoryRecord) onTap;
  final void Function(HistoryRecord) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final byYear = <int, List<HistoryRecord>>{};
    for (final r in records) {
      byYear.putIfAbsent(r.performedAt.year, () => []).add(r);
    }
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final items = byYear[year]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
              child: Text(
                '$year',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              HistoryCard(
                record: items[i],
                onTap: () => onTap(items[i]),
                onDelete: () => onDelete(items[i]),
              ),
            ],
          ],
        );
      },
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
              Icons.history_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.historyEmptyTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.historyEmptyMessage,
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
              label: Text(l10n.historyHowItWorks),
            ),
          ],
        ),
      ),
    );
  }
}
