// integration_test/test_app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carlog/app.dart';
import 'package:carlog/data/database.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/export_import_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/backup_service.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/services/reminder_service.dart';

/// Запуск приложения для интеграционных тестов.
///
/// Отличия от production `main.dart`:
/// - БД in-memory (`sqflite_common_ffi`).
/// - Нет `WorkManager`.
/// - Нет `NotificationService.init()` / `requestPermissions()`.
/// - Язык принудительно `'en'` — тесты ищут английские строки.
/// - Загрузку данных делает `SplashScreen` — как в production.
Future<void> runTestApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Сброс существующей фабрики, чтобы избежать предупреждения sqflite
  databaseFactoryOrNull = null;

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = AppDatabase();
  if (db.isOpen) await db.close();
  await db.openInMemory(factory: databaseFactoryFfi);

  // Принудительно английский язык — тесты ищут английские строки.
  await db.settings.setLocale('en');

  final settings = SettingsProvider(db);
  final mileage = MileageProvider(db);
  final rules = RulesProvider(db);
  final history = HistoryProvider(db);
  final postponements = PostponementsProvider(db);

  final dueList = DueListProvider(
    db,
    mileage: mileage,
    rules: rules,
    history: history,
    settings: settings,
    postponements: postponements,
  );

  final notifications = NotificationService();

  final reminder = ReminderService(
    settings: settings,
    mileage: mileage,
    rules: rules,
    notifications: notifications,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        Provider<NotificationService>.value(value: notifications),
        Provider<ReminderService>.value(value: reminder),
        Provider<BackupService>(create: (_) => BackupService(db)),
        ChangeNotifierProvider<SettingsProvider>.value(value: settings),
        ChangeNotifierProvider<MileageProvider>.value(value: mileage),
        ChangeNotifierProvider<RulesProvider>.value(value: rules),
        ChangeNotifierProvider<HistoryProvider>.value(value: history),
        ChangeNotifierProvider<PostponementsProvider>.value(
          value: postponements,
        ),
        ChangeNotifierProvider<DueListProvider>.value(value: dueList),
        ChangeNotifierProvider(create: (_) => ExportImportProvider(db)),
      ],
      child: const CarlogApp(),
    ),
  );
}
