// lib/main.dart

import 'dart:io' show Platform;

import 'package:carlog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:workmanager/workmanager.dart';

import 'package:carlog/app.dart';
import 'package:carlog/data/database.dart';
import 'package:carlog/providers/due_list_provider.dart';
import 'package:carlog/providers/export_import_provider.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/background_worker.dart';
import 'package:carlog/services/backup_service.dart';
import 'package:carlog/services/notification_service.dart';
import 'package:carlog/services/reminder_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final notifications = NotificationService();
  if (Platform.isAndroid || Platform.isIOS) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final l10n = await AppLocalizations.delegate.load(locale);

    await notifications.init(
      channelName: l10n.notificationChannelName,
      channelDescription: l10n.notificationChannelDescription,
    );
    // requestPermissions() перенесён в SplashScreen — там показывается
    // свой диалог перед системным.
  }

  if (Platform.isAndroid || Platform.isIOS) {
    await Workmanager().initialize(callbackDispatcher);
    await registerMileageReminderTask();
  }

  final db = AppDatabase();
  await db.open();

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
