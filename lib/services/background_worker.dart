// lib/services/background_worker.dart

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/utils/formatting.dart';

/// Уникальное имя периодической задачи.
const String kMileageReminderTask = 'mileageReminderTask';

/// Уникальное имя задачи (для регистрации).
const String kMileageReminderTaskName = 'mileage_reminder';

/// Диспетчер фоновых задач.
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

/// Фоновая проверка: пора ли напомнить о пробеге.
///
/// Работает в отдельном изоляте. БД открывается напрямую,
/// только на чтение. НЕ закрывается — процесс завершится сам.
/// НЕ пишет в БД — чтобы не конфликтовать с основным приложением.
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

    final notifications = await NotificationService.initForBackground();
    await notifications.showMileageReminder(
      carName: settings.carName,
      daysSinceUpdate: days,
    );
  } catch (e) {
    debugPrint('Background task error: $e');
  }
  // db.close() НЕ вызываем.
}

/// Зарегистрировать периодическую задачу WorkManager.
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

/// Отменить периодическую задачу.
Future<void> cancelMileageReminderTask() async {
  await Workmanager().cancelByUniqueName(kMileageReminderTaskName);
}
