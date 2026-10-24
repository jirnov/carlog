// lib/screens/home/home_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/postpone_dialog.dart';
import 'package:carlog/dialogs/update_mileage_dialog.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/screens/help/help_screen.dart';
import 'package:carlog/screens/main/widgets/settings_action.dart';
import 'package:carlog/screens/mark_done/mark_done_multi_screen.dart';
import 'package:carlog/screens/mark_done/mark_done_screen.dart';
import 'package:carlog/services/history_service.dart';
import 'package:carlog/services/maintenance_service.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/services/reminder_service.dart';
import 'package:carlog/utils/formatting.dart';
import 'widgets/due_card.dart';
import 'widgets/mileage_header.dart';
import 'widgets/nearest_due_label.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

/// Публичный state — чтобы MainScreen мог управлять режимом выбора
/// через GlobalKey.
class HomeScreenState extends State<HomeScreen> {
  static const _historyService = HistoryService();
  static const _highlightDuration = Duration(seconds: 3);

  NotificationService? _notifications;

  int? _highlightedRuleId;
  Timer? _highlightTimer;

  /// Режим мультивыбора.
  bool _selectionMode = false;
  final Set<int> _selectedRuleIds = {};

  /// Публичный геттер — MainScreen проверяет, в режиме ли выбора.
  bool get isSelectionMode => _selectionMode;

  /// Публичный метод — MainScreen вызывает по Back.
  void exitSelectionMode() {
    if (!_selectionMode) return;
    _exitSelectionMode();
  }

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationService>();
    _notifications!.openMileageRequests.addListener(_onOpenMileageRequest);

    if (_notifications!.pendingOpenMileage) {
      _notifications!.pendingOpenMileage = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _onUpdateMileage();
      });
    }
  }

  @override
  void dispose() {
    _notifications?.openMileageRequests.removeListener(_onOpenMileageRequest);
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _onOpenMileageRequest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onUpdateMileage();
    });
  }

  Future<void> _onUpdateMileage() async {
    final mileageProvider = context.read<MileageProvider>();
    final reminder = context.read<ReminderService>();
    final current = mileageProvider.currentMileage;

    final newMileage = await showUpdateMileageDialog(
      context,
      previousMileage: current,
    );
    if (newMileage == null) return;
    if (!mounted) return;

    await mileageProvider.add(newMileage);
    await reminder.reset();
  }

  // --- Мультивыбор ---

  void _enterSelectionMode(int ruleId) {
    setState(() {
      _selectionMode = true;
      _selectedRuleIds
        ..clear()
        ..add(ruleId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedRuleIds.clear();
    });
  }

  void _toggleSelection(int ruleId) {
    setState(() {
      if (_selectedRuleIds.contains(ruleId)) {
        _selectedRuleIds.remove(ruleId);
        if (_selectedRuleIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedRuleIds.add(ruleId);
      }
    });
  }

  Future<void> _onMarkDoneSelected() async {
    final selectedRules = context
        .read<RulesProvider>()
        .rules
        .where((r) => _selectedRuleIds.contains(r.id))
        .toList();

    if (selectedRules.isEmpty) return;

    final postponementsProvider = context.read<PostponementsProvider>();
    final rulesProvider = context.read<RulesProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final mileageProvider = context.read<MileageProvider>();

    final result = await showMarkDoneMultiScreen(
      context,
      rules: selectedRules,
    );
    if (result == null) return;
    if (!mounted) return;

    // Для каждого правила: advance + removeForRule + history.
    for (final rule in selectedRules) {
      await rulesProvider.advance(
        rule.id!,
        performedMileage: result.mileage,
        performedDate: result.performedAt,
      );
      await postponementsProvider.removeForRule(rule.id!);

      await historyProvider.add(HistoryRecord(
        title: rule.title,
        note: result.note,
        mileage: result.mileage,
        performedAt: result.performedAt,
        cost: null,
      ));
    }

    if (!mounted) return;

    // Пробег машины — один раз.
    if (result.updatedMileage != null) {
      await mileageProvider.add(result.updatedMileage!);
      if (!mounted) return;
      await context.read<ReminderService>().reset();
      if (!mounted) return;
    }

    _exitSelectionMode();

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          l10n.homeDoneSelectedSnack(
            count: selectedRules.length,
            km: formatThousands(result.mileage, locale),
            date: formatMonthYear(result.performedAt, locale),
          ),
        ),
      ),
    );
  }

  // --- Одиночное выполнение ---

  Future<void> _onMarkDone(Rule rule) async {
    final postponementsProvider = context.read<PostponementsProvider>();
    final result = await showMarkDoneScreen(context, rule: rule);
    if (result == null) return;
    if (!mounted) return;

    await context.read<RulesProvider>().advance(
          rule.id!,
          performedMileage: result.record.mileage,
          performedDate: result.record.performedAt,
        );

    await postponementsProvider.removeForRule(rule.id!);

    if (!mounted) return;

    await _historyService.applyMarkDoneFromHome(
      result: result,
      history: context.read<HistoryProvider>(),
      mileage: context.read<MileageProvider>(),
    );

    if (!mounted) return;

    if (result.updatedMileage != null) {
      await context.read<MileageProvider>().add(result.updatedMileage!);
      if (!mounted) return;
      await context.read<ReminderService>().reset();
      if (!mounted) return;
    }

    _highlightTimer?.cancel();
    setState(() => _highlightedRuleId = rule.id);
    _highlightTimer = Timer(_highlightDuration, () {
      if (mounted) {
        setState(() => _highlightedRuleId = null);
      }
    });

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          l10n.homeDoneSingleSnack(
            title: rule.title,
            km: formatThousands(result.record.mileage, locale),
            date: formatMonthYear(result.record.performedAt, locale),
          ),
        ),
      ),
    );
  }

  Future<void> _onPostpone(DueInfo due) async {
    final date = await showPostponeDialog(
      context,
      ruleTitle: due.rule.title,
    );
    if (date == null) return;
    if (!mounted) return;

    await context
        .read<PostponementsProvider>()
        .postponeRule(due.rule.id!, date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final carName = context.select<SettingsProvider, String>(
      (p) => p.carName,
    );
    final mileage = context.select<MileageProvider, int>(
      (p) => p.currentMileage,
    );
    final lastUpdated = context.select<MileageProvider, DateTime?>(
      (p) => p.lastUpdatedAt,
    );
    final remindEnabled = context.select<SettingsProvider, bool>(
      (p) => p.remindEnabled,
    );
    final remindDays = context.select<SettingsProvider, int>(
      (p) => p.remindDays,
    );
    final dues = context.watch<DueListProvider>().items;

    final active = dues.where((d) => !d.isPostponed).toList();
    final postponed = dues.where((d) => d.isPostponed).toList();

    // Без PopScope — Back обрабатывается в MainScreen.
    return Scaffold(
      appBar: AppBar(
        leading: _selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
                tooltip: l10n.actionCancel,
              )
            : null,
        title: _selectionMode
            ? Text(l10n.homeSelectionCount(count: _selectedRuleIds.length))
            : Text(
                carName.isEmpty ? l10n.homeCarNameFallback : carName,
              ),
        actions: _selectionMode ? null : const [SettingsAction()],
      ),
      body: Column(
        children: [
          MileageHeader(
            mileage: mileage,
            lastUpdatedAt: lastUpdated,
            remindEnabled: remindEnabled,
            remindDays: remindDays,
            onUpdate: _onUpdateMileage,
          ),
          if (!_selectionMode && active.isNotEmpty)
            NearestDueLabel(due: active.first),
          const SizedBox(height: 8),
          Expanded(
            child: dues.isEmpty
                ? const _EmptyState()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      for (final due in active) ...[
                        DueCard(
                          due: due,
                          highlighted: due.rule.id == _highlightedRuleId,
                          selectionMode: _selectionMode,
                          selected: _selectedRuleIds.contains(due.rule.id),
                          onLongPress: () => _enterSelectionMode(due.rule.id!),
                          onTapInSelection: () =>
                              _toggleSelection(due.rule.id!),
                          onMarkDone: () => _onMarkDone(due.rule),
                          onPostpone: () => _onPostpone(due),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (postponed.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            bottom: 8,
                          ),
                          child: Text(
                            l10n.homePostponedSection,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ),
                        for (final due in postponed) ...[
                          DueCard(
                            due: due,
                            highlighted: due.rule.id == _highlightedRuleId,
                            selectionMode: _selectionMode,
                            selected: _selectedRuleIds.contains(due.rule.id),
                            onLongPress: () =>
                                _enterSelectionMode(due.rule.id!),
                            onTapInSelection: () =>
                                _toggleSelection(due.rule.id!),
                            onMarkDone: () => _onMarkDone(due.rule),
                            onPostpone: () => _onPostpone(due),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: _selectionMode && _selectedRuleIds.isNotEmpty
          ? FloatingActionButton.extended(
              heroTag: 'fab_mark_done_selected',
              onPressed: _onMarkDoneSelected,
              icon: const Icon(Icons.done_all),
              label: Text(
                l10n.homeMarkDoneSelected(count: _selectedRuleIds.length),
              ),
            )
          : null,
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
              Icons.checklist_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeEmptyTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeEmptyMessage,
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
              label: Text(l10n.howItWorks),
            ),
          ],
        ),
      ),
    );
  }
}
