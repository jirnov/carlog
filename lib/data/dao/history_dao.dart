// lib/data/dao/history_dao.dart
import 'package:sqflite/sqflite.dart';
import '../models/history_record.dart';

class HistoryDao {
  HistoryDao(this._db);
  final Database _db;

  static const _table = 'history';

  /// Все записи, от новых к старым.
  Future<List<HistoryRecord>> getAll() async {
    final rows = await _db.query(_table, orderBy: 'performed_at DESC');
    return rows.map(HistoryRecord.fromMap).toList();
  }

  /// Все записи по конкретному правилу, от новых к старым.
  Future<List<HistoryRecord>> getByRule(int ruleId) async {
    final rows = await _db.query(
      _table,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
      orderBy: 'performed_at DESC',
    );
    return rows.map(HistoryRecord.fromMap).toList();
  }

  /// Последняя (свежая) запись по правилу — используется для расчёта
  /// точки отсчёта следующего ТО.
  Future<HistoryRecord?> getLastByRule(int ruleId) async {
    final rows = await _db.query(
      _table,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
      orderBy: 'performed_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HistoryRecord.fromMap(rows.first);
  }

  Future<HistoryRecord?> getById(int id) async {
    final rows = await _db.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HistoryRecord.fromMap(rows.first);
  }

  Future<int> insert(HistoryRecord record) async {
    return _db.insert(_table, record.toMap());
  }

  Future<void> update(HistoryRecord record) async {
    if (record.id == null) {
      throw ArgumentError('Нельзя обновить запись без id');
    }
    await _db.update(
      _table,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> delete(int id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Записи за период — например, для будущей статистики.
  Future<List<HistoryRecord>> getBetween(DateTime from, DateTime to) async {
    final rows = await _db.query(
      _table,
      where: 'performed_at >= ? AND performed_at <= ?',
      whereArgs: [from.toIso8601String(), to.toIso8601String()],
      orderBy: 'performed_at DESC',
    );
    return rows.map(HistoryRecord.fromMap).toList();
  }
}