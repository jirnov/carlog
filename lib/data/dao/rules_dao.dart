// lib/data/dao/rules_dao.dart
import 'package:sqflite/sqflite.dart';
import '../models/rule.dart';

class RulesDao {
  RulesDao(this._db);
  final Database _db;

  static const _table = 'rules';

  /// Все правила, отсортированные по порядку создания.
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

  /// Вставить правило. Возвращает id новой записи.
  Future<int> insert(Rule rule) async {
    return _db.insert(_table, rule.toMap());
  }

  /// Обновить правило по id.
  Future<void> update(Rule rule) async {
    if (rule.id == null) {
      throw ArgumentError('Нельзя обновить правило без id');
    }
    await _db.update(
      _table,
      rule.toMap(),
      where: 'id = ?',
      whereArgs: [rule.id],
    );
  }

  /// Удалить правило. В history связанные записи получат rule_id = NULL,
  /// потому что в схеме стоит ON DELETE SET NULL и включены foreign_keys.
  Future<void> delete(int id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Количество правил — для проверки «регламент не заполнен».
  Future<int> count() async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS c FROM $_table');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}