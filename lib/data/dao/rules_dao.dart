// lib/data/dao/rules_dao.dart

import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/models/rule.dart';
import 'package:carlog/utils/formatting.dart';

class RulesDao {
  RulesDao(this._db);

  final Database _db;

  static const _table = 'rules';

  Future<List<Rule>> getAll() async {
    final rows = await _db.query(_table, orderBy: 'id ASC');
    return rows.map(Rule.fromMap).toList();
  }

  Future<Rule?> getById(int id) async {
    final rows = await _db.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Rule.fromMap(rows.first);
  }

  Future<int> insert(Rule rule) async {
    final map = Map<String, Object?>.from(rule.toMap())..remove('id');
    return _db.insert(_table, map);
  }

  Future<void> update(Rule rule) async {
    if (rule.id == null) {
      throw ArgumentError('Cannot update rule without id');
    }
    await _db.update(
      _table,
      rule.toMap(),
      where: 'id = ?',
      whereArgs: [rule.id],
    );
  }

  /// Сдвинуть следующее ТО после выполнения.
  ///
  /// И пробег, и дата считаются строго от факта выполнения:
  /// `next_km = performedMileage + interval_km`,
  /// `next_date = performedDate + interval_months`.
  ///
  /// Старое значение `next_km` не учитывается: если пользователь выполнил
  /// ТО раньше плана, следующее сдвигается соответственно.
  Future<void> advance(
    int ruleId, {
    required int performedMileage,
    required DateTime performedDate,
  }) async {
    final rule = await getById(ruleId);
    if (rule == null) return;

    final values = <String, Object?>{};

    final intervalKm = rule.intervalKm;
    if (intervalKm != null && intervalKm > 0) {
      values['next_km'] = performedMileage + intervalKm;
    }

    final intervalMonths = rule.intervalMonths;
    if (intervalMonths != null && intervalMonths > 0) {
      final newNextDate = _addMonths(performedDate, intervalMonths);
      values['next_date'] = formatDateOnly(newNextDate);
    }

    if (values.isEmpty) return;

    await _db.update(
      _table,
      values,
      where: 'id = ?',
      whereArgs: [ruleId],
    );
  }

  Future<void> delete(int id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS c FROM $_table');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Прибавить месяцы к дате. Всегда возвращает 15-е число месяца результата.
  ///
  /// 2026-10-15 + 12 → 2027-10-15.
  DateTime _addMonths(DateTime date, int months) {
    final m = date.month - 1 + months;
    final year = date.year + m ~/ 12;
    final month = m % 12 + 1;
    return DateTime(year, month, 15);
  }
}
