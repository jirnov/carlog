// lib/data/dao/history_dao.dart

import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/models/history_record.dart';

class HistoryDao {
  HistoryDao(this._db);

  final Database _db;

  static const _table = 'history';

  Future<List<HistoryRecord>> getAll() async {
    final rows = await _db.query(
      _table,
      orderBy: 'performed_at DESC, id DESC',
    );
    return rows.map(HistoryRecord.fromMap).toList();
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
    final map = Map<String, Object?>.from(record.toMap())..remove('id');
    return _db.insert(_table, map);
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
}
