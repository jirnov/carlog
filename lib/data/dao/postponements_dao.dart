// lib/data/dao/postponements_dao.dart

import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/models/postponement.dart';

class PostponementsDao {
  PostponementsDao(this._db);

  final Database _db;

  static const _table = 'postponements';

  /// Все отложки.
  Future<List<Postponement>> getAll() async {
    final rows = await _db.query(_table);
    return rows.map(Postponement.fromMap).toList();
  }

  /// Отложка для конкретного правила, если есть.
  Future<Postponement?> getForRule(int ruleId) async {
    final rows = await _db.query(
      _table,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Postponement.fromMap(rows.first);
  }

  /// Сохранить отложку. Если для правила уже есть — перезаписать.
  Future<void> save(Postponement postponement) async {
    await _db.insert(
      _table,
      postponement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Удалить отложку для правила.
  Future<void> removeForRule(int ruleId) async {
    await _db.delete(
      _table,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
    );
  }

  /// Удалить все отложки.
  Future<void> clear() async {
    await _db.delete(_table);
  }
}
