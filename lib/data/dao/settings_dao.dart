// lib/data/dao/settings_dao.dart

import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/models/settings.dart';
import 'package:carlog/data/models/theme_mode_preference.dart';

class SettingsDao {
  SettingsDao(this._db);

  final Database _db;

  static const _table = 'settings';
  static const _id = 1;

  Future<Settings> get() async {
    final rows = await _db.query(
      _table,
      where: 'id = ?',
      whereArgs: [_id],
    );
    if (rows.isEmpty) {
      throw StateError('Строка settings с id=1 отсутствует');
    }
    return Settings.fromMap(rows.first);
  }

  Future<void> update(Map<String, Object?> values) async {
    await _db.update(_table, values, where: 'id = ?', whereArgs: [_id]);
  }

  Future<void> setCarName(String value) => update({'car_name': value});

  Future<void> setOnboardingDone(bool value) =>
      update({'onboarding_done': value ? 1 : 0});

  Future<void> setRemindEnabled(bool value) =>
      update({'remind_enabled': value ? 1 : 0});

  Future<void> setRemindDays(int value) => update({'remind_days': value});

  Future<void> setYellowKm(int value) => update({'yellow_km': value});

  Future<void> setYellowMonths(int value) => update({'yellow_months': value});

  Future<void> setThemeMode(ThemeModePreference value) =>
      update({'theme_mode': value.name});
}
