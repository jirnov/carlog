// lib/services/reminder_service.dart

import 'package:flutter/widgets.dart';

import 'package:carlog/l10n/app_localizations.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/services/notification_texts.dart';
import 'package:carlog/utils/formatting.dart';

/// Во сколько показывать уведомление по расписанию.
const int _scheduledHour = 10;

class ReminderService {
  ReminderService({
    required SettingsProvider settings,
    required MileageProvider mileage,
    required RulesProvider rules,
    required NotificationService notifications,
  })  : _settings = settings,
        _mileage = mileage,
        _rules = rules,
        _notifications = notifications;

  final SettingsProvider _settings;
  final MileageProvider _mileage;
  final RulesProvider _rules;
  final NotificationService _notifications;

  /// Пора ли напоминать.
  bool get shouldRemind {
    if (!_settings.remindEnabled) return false;
    if (_rules.rules.isEmpty) return false;

    final lastUpdated = _mileage.lastUpdatedAt;
    if (lastUpdated == null) return false;

    final days = _daysSinceUpdate;
    if (days == null) return false;
    return days >= _settings.remindDays;
  }

  /// Сколько календарных дней прошло с последнего обновления.
  int? get _daysSinceUpdate {
    final lastUpdated = _mileage.lastUpdatedAt;
    if (lastUpdated == null) return null;
    final today = dateOnly(DateTime.now());
    final updated = dateOnly(lastUpdated);
    return today.difference(updated).inDays;
  }

  /// Локаль для текстов уведомления.
  /// Берём системную; если хотите следовать языку приложения —
  /// сохраняйте выбранную локаль в настройках и читайте здесь.
  Locale get _locale => WidgetsBinding.instance.platformDispatcher.locale;

  /// Запланировать следующую проверку на завтра в 10:00.
  /// Вызывается после каждой успешной проверки.
  Future<void> scheduleNextCheck() async {
    if (!_settings.remindEnabled) {
      await _notifications.cancelMileageReminder();
      return;
    }

    final tomorrow = dateOnly(DateTime.now()).add(const Duration(days: 1));
    final when = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      _scheduledHour,
    );

    final days = _daysSinceUpdate ?? 0;

    final l10n = await AppLocalizations.delegate.load(_locale);
    final texts = NotificationTexts.fromL10n(
      l10n,
      carName: _settings.carName,
      daysSinceUpdate: days,
    );

    await _notifications.scheduleMileageReminder(
      when: when,
      texts: texts,
    );
  }

  /// Сбросить напоминания — например, после обновления пробега.
  Future<void> reset() async {
    await _notifications.cancelMileageReminder();
    await scheduleNextCheck();
  }
}
