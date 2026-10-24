// lib/services/background_worker.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/l10n/app_localizations.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/services/notification_texts.dart';
import 'package:carlog/utils/formatting.dart';

const String kMileageReminderTask = 'mileageReminderTask';
const String kMileageReminderTaskName = 'mileage_reminder';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('WorkManager task: $task');

    if (task == kMileageReminderTask) {
      await _checkMileageReminder();
    }

    return Future.value(true);
  });
}

Future<void> _checkMileageReminder() async {
  final db = AppDatabase();
  await db.open();

  try {
    final settings = await db.settings.get();
    if (!settings.remindEnabled) return;

    final rules = await db.rules.getAll();
    if (rules.isEmpty) return;

    final lastMileage = await db.mileage.getCurrent();
    if (lastMileage == null) return;

    final today = dateOnly(DateTime.now());
    final updated = dateOnly(lastMileage.recordedAt);

    final days = today.difference(updated).inDays;
    if (days < settings.remindDays) return;

    // Локаль для уведомления. Можно взять системную или сохранённую.
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final l10n = await AppLocalizations.delegate.load(locale);

    final texts = NotificationTexts.fromL10n(
      l10n,
      carName: settings.carName,
      daysSinceUpdate: days,
    );

    final notifications = await NotificationService.initForBackground();
    await notifications.showMileageReminder(texts: texts);
  } catch (e) {
    debugPrint('Background task error: $e');
  }
  // db.close() НЕ вызываем.
}

Future<void> registerMileageReminderTask() async {
  await Workmanager().registerPeriodicTask(
    kMileageReminderTaskName,
    kMileageReminderTask,
    frequency: const Duration(hours: 24),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

Future<void> cancelMileageReminderTask() async {
  await Workmanager().cancelByUniqueName(kMileageReminderTaskName);
}
