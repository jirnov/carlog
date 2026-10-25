// test/services/export_import_service_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/rule.dart';
import 'package:carlog/services/export_import_service.dart';

void main() {
  late AppDatabase db;
  late ExportImportService service;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = AppDatabase();
    if (db.isOpen) await db.close();
    await db.openInMemory(factory: databaseFactoryFfi);
    service = ExportImportService(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedData() async {
    await db.rules.insert(const Rule(
      title: 'Масло',
      nextKm: 240000,
      intervalKm: 10000,
      cost: 5000,
    ));
    await db.rules.insert(const Rule(
      title: 'Колодки',
      nextKm: 30000,
      intervalKm: 30000,
    ));
    await db.db.insert('history', {
      'title': 'Масло',
      'note': '',
      'mileage': 240000,
      'performed_at': '2026-10-15',
      'cost': 5000,
    });
    await db.db.insert('mileage_log', {
      'mileage': 240000,
      'recorded_at': '2026-10-15',
    });
  }

  group('exportToJson', () {
    test('возвращает валидный JSON с маркером и версией', () async {
      final json = await service.exportToJson();
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded['app'], 'carlog');
      expect(decoded['schema_version'], AppDatabase.currentVersion);
      expect(decoded['exported_at'], isA<String>());
      expect(decoded['settings'], isA<Map<String, dynamic>>());
      expect(decoded['rules'], isA<List>());
      expect(decoded['history'], isA<List>());
      expect(decoded['mileage_log'], isA<List>());
      expect(decoded['postponements'], isA<List>());
    });

    test('settings в JSON содержит только car_name и onboarding_done',
        () async {
      await seedData();

      final json = await service.exportToJson();
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final settings = decoded['settings'] as Map<String, dynamic>;

      expect(settings.keys.toSet(), {'car_name', 'onboarding_done'});
    });

    test('экспортирует данные из БД', () async {
      await seedData();

      final json = await service.exportToJson();
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect((decoded['rules'] as List).length, 2);
      expect((decoded['history'] as List).length, 1);
      expect((decoded['mileage_log'] as List).length, 1);
    });
  });

  group('importFromJson — ошибки', () {
    test('битый JSON → исключение', () async {
      expect(
        () => service.importFromJson('not a json'),
        throwsA(isA<Exception>()),
      );
    });

    test('чужое приложение → исключение', () async {
      final json = jsonEncode({'app': 'other', 'schema_version': 2});
      expect(
        () => service.importFromJson(json),
        throwsA(isA<Exception>()),
      );
    });

    test('версия выше текущей → исключение', () async {
      final json = jsonEncode({
        'app': 'carlog',
        'schema_version': AppDatabase.currentVersion + 1,
      });
      expect(
        () => service.importFromJson(json),
        throwsA(isA<Exception>()),
      );
    });

    test('версия ниже минимальной → исключение', () async {
      final json = jsonEncode({'app': 'carlog', 'schema_version': 0});
      expect(
        () => service.importFromJson(json),
        throwsA(isA<Exception>()),
      );
    });

    test('неверный формат (не Map) → исключение', () async {
      expect(
        () => service.importFromJson('[]'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('importFromJson — успех', () {
    test('v1 (старая) → конвертация, не падает', () async {
      final json = jsonEncode({
        'app': 'carlog',
        'schema_version': 1,
        'settings': {
          'car_name': 'Старая машина',
          'remind_enabled': 0,
          'remind_days': 60,
          'yellow_km': 1000,
          'yellow_months': 2,
          'onboarding_done': 1,
          'theme_mode': 'dark',
        },
        'rules': [],
        'history': [],
        'mileage_log': [],
        'postponements': [],
      });

      await service.importFromJson(json);

      final rules = await db.rules.getAll();
      expect(rules, isEmpty);

      // car_name и onboarding_done — из JSON.
      final settings = await db.settings.get();
      expect(settings.carName, 'Старая машина');
      expect(settings.onboardingDone, isTrue);

      // Остальные настройки — не тронуты.
      expect(settings.remindDays, 30); // default, не 60
      expect(settings.themeMode.name, 'system'); // default, не dark
    });

    test('пустые таблицы → не падает', () async {
      final json = jsonEncode({
        'app': 'carlog',
        'schema_version': AppDatabase.currentVersion,
        'settings': null,
        'rules': [],
        'history': [],
        'mileage_log': [],
        'postponements': [],
      });

      await service.importFromJson(json);

      final rules = await db.rules.getAll();
      expect(rules, isEmpty);
    });

    test('заменяет существующие данные', () async {
      await seedData();

      final json = jsonEncode({
        'app': 'carlog',
        'schema_version': AppDatabase.currentVersion,
        'settings': {
          'car_name': 'Новая машина',
          'onboarding_done': 1,
        },
        'rules': [
          {
            'id': 1,
            'title': 'Новое правило',
            'note': '',
            'next_km': 50000,
            'next_date': null,
            'interval_km': 5000,
            'interval_months': null,
            'cost': null,
          },
        ],
        'history': [],
        'mileage_log': [],
        'postponements': [],
      });

      await service.importFromJson(json);

      final rules = await db.rules.getAll();
      expect(rules.length, 1);
      expect(rules.first.title, 'Новое правило');

      final settings = await db.settings.get();
      expect(settings.carName, 'Новая машина');
    });

    test('round-trip: экспорт → импорт → данные те же', () async {
      await seedData();

      final json = await service.exportToJson();
      await service.importFromJson(json);

      final rules = await db.rules.getAll();
      expect(rules.length, 2);
      expect(rules.any((r) => r.title == 'Масло'), isTrue);
      expect(rules.any((r) => r.title == 'Колодки'), isTrue);

      final history = await db.db.query('history');
      expect(history.length, 1);
    });
  });
}
