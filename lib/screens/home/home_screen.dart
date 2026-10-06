// lib/screens/home/home_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/dialogs/postpone_dialog.dart';
import 'package:carlog/dialogs/update_mileage_dialog.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/screens/main/widgets/settings_action.dart';
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _historyService = HistoryService();
  static const _highlightDuration = Duration(seconds: 3);

  NotificationService? _notifications;

  /// id правила, которое только что выполнено — подсвечиваем его карточку.
  int? _highlightedRuleId;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    _notifications = context.read<NotificationService>();
    _notifications!.openMileageRequests.addListener(_onOpenMileageRequest);
  }

  @override
  void dispose() {
    _notifications?.openMileageRequests.removeListener(_onOpenMileageRequest);
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _onOpenMileageRequest() {
    // Приложение могли только что открыть из уведомления —
    // даём кадру построиться, потом показываем диалог.
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

    // Сбросить напоминание о пробеге — данные обновлены.
    await reminder.reset();
  }

  Future<void> _onMarkDone(Rule rule) async {
    final postponementsProvider = context.read<PostponementsProvider>();
    final result = await showMarkDoneScreen(context, rule: rule);
    if (result == null) return;
    if (!mounted) return;

    // Сдвигаем правило и снимаем отложку до записи в историю.
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

    // Обновляем пробег машины, если пользователь подтвердил в MarkDoneScreen.
    if (result.updatedMileage != null) {
      await context.read<MileageProvider>().add(result.updatedMileage!);
      if (!mounted) return;
      await context.read<ReminderService>().reset();
      if (!mounted) return;
    }

    // Подсветить карточку с этим правилом.
    _highlightTimer?.cancel();
    setState(() => _highlightedRuleId = rule.id);
    _highlightTimer = Timer(_highlightDuration, () {
      if (mounted) {
        setState(() => _highlightedRuleId = null);
      }
    });

    // SnackBar с данными из истории: пробег и дата выполнения.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          '${rule.title} выполнено — '
          '${formatThousands(result.record.mileage)} км, '
          '${formatMonthYear(result.record.performedAt)}',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(carName.isEmpty ? 'Мой автомобиль' : carName),
        actions: const [SettingsAction()],
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
          if (active.isNotEmpty) NearestDueLabel(due: active.first),
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
                            'Отложенные',
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
              Icons.checklist_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'График работ пуст',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте плановое ТО на вкладке «Планирование»',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
