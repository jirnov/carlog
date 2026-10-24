// lib/services/export_import_service.dart

import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/database.dart';

const int _schemaVersion = 1;
const String _appMarker = 'carlog';

class ExportImportService {
  ExportImportService(this._db);

  final AppDatabase _db;

  /// Собрать все данные в JSON-строку.
  Future<String> exportToJson() async {
    final db = _db.db;

    final settingsRows = await db.query('settings', limit: 1);
    final rulesRows = await db.query('rules');
    final historyRows = await db.query('history');
    final mileageRows = await db.query('mileage_log');
    final postponementsRows = await db.query('postponements');

    final data = {
      'app': _appMarker,
      'schema_version': _schemaVersion,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'settings': settingsRows.isEmpty ? null : settingsRows.first,
      'rules': rulesRows,
      'history': historyRows,
      'mileage_log': mileageRows,
      'postponements': postponementsRows,
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Импортировать данные из JSON-строки.
  /// Бросает исключение, если формат неверный или версия несовместима.
  Future<void> importFromJson(String content) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(content);
    } catch (e) {
      throw Exception('File is corrupted or is not JSON');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid file format');
    }

    if (decoded['app'] != _appMarker) {
      throw Exception('File is from another app');
    }

    final version = decoded['schema_version'];
    if (version is! int || version != _schemaVersion) {
      throw Exception(
        'File version ($version) is incompatible with the current '
        '($_schemaVersion). Import is only possible for this version.',
      );
    }

    final db = _db.db;

    await db.transaction((txn) async {
      // 1. Очистить таблицы.
      await txn.delete('history');
      await txn.delete('rules');
      await txn.delete('mileage_log');
      await txn.delete('postponements');
      await txn.delete('settings');

      // 2. Settings.
      final settings = decoded['settings'];
      if (settings is Map<String, dynamic>) {
        await txn.insert('settings', {
          'id': 1,
          'car_name': settings['car_name'] ?? '',
          'remind_enabled': settings['remind_enabled'] ?? 1,
          'remind_days': settings['remind_days'] ?? 30,
          'yellow_km': settings['yellow_km'] ?? 500,
          'yellow_months': settings['yellow_months'] ?? 1,
          'onboarding_done': settings['onboarding_done'] ?? 1,
          'theme_mode': settings['theme_mode'] ?? 'system',
        });
      } else {
        await txn.insert('settings', {
          'id': 1,
          'car_name': '',
          'remind_enabled': 1,
          'remind_days': 30,
          'yellow_km': 500,
          'yellow_months': 1,
          'onboarding_done': 1,
          'theme_mode': 'system',
        });
      }

      // 3. Rules.
      final rules = decoded['rules'];
      if (rules is List) {
        for (final rule in rules) {
          if (rule is! Map<String, dynamic>) continue;
          await txn.insert(
            'rules',
            {
              'id': rule['id'],
              'title': rule['title'] ?? '',
              'note': rule['note'] ?? '',
              'next_km': rule['next_km'],
              'next_date': rule['next_date'],
              'interval_km': rule['interval_km'],
              'interval_months': rule['interval_months'],
              'cost': rule['cost'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      // 4. History.
      final history = decoded['history'];
      if (history is List) {
        for (final record in history) {
          if (record is! Map<String, dynamic>) continue;
          await txn.insert(
            'history',
            {
              'id': record['id'],
              'title': record['title'] ?? '',
              'note': record['note'] ?? '',
              'mileage': record['mileage'] ?? 0,
              'performed_at': record['performed_at'] ?? '',
              'cost': record['cost'],
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      // 5. Mileage log.
      final mileage = decoded['mileage_log'];
      if (mileage is List) {
        for (final entry in mileage) {
          if (entry is! Map<String, dynamic>) continue;
          await txn.insert(
            'mileage_log',
            {
              'mileage': entry['mileage'] ?? 0,
              'recorded_at': entry['recorded_at'] ?? '',
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }

      // 6. Postponements.
      final postponements = decoded['postponements'];
      if (postponements is List) {
        for (final p in postponements) {
          if (p is! Map<String, dynamic>) continue;
          await txn.insert(
            'postponements',
            {
              'rule_id': p['rule_id'],
              'until_date': p['until_date'] ?? '',
              'created_at': p['created_at'] ?? '',
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }
}
