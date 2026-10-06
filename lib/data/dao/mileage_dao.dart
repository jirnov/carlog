// lib/data/dao/mileage_dao.dart

import 'package:carlog/utils/formatting.dart';
import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/models/mileage_entry.dart';

class MileageDao {
  MileageDao(this._db);

  final Database _db;

  static const _table = 'mileage_log';

  /// Вся история. Сортировка — от новых записей к старым по дате.
  /// При равных датах — по убыванию пробега.
  Future<List<MileageEntry>> getAll() async {
    final rows = await _db.query(
      _table,
      orderBy: 'recorded_at DESC, mileage DESC',
    );
    return rows.map(MileageEntry.fromMap).toList();
  }

  /// Текущий пробег — максимальное значение в журнале.
  Future<MileageEntry?> getCurrent() async {
    final rows = await _db.query(
      _table,
      orderBy: 'mileage DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MileageEntry.fromMap(rows.first);
  }

  /// Начало учёта — минимальный пробег.
  Future<MileageEntry?> getFirst() async {
    final rows = await _db.query(
      _table,
      orderBy: 'mileage ASC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MileageEntry.fromMap(rows.first);
  }

  /// Последние N записей по дате (для расчёта среднесуточного темпа).
  Future<List<MileageEntry>> getLast(int limit) async {
    final rows = await _db.query(
      _table,
      orderBy: 'recorded_at DESC, mileage DESC',
      limit: limit,
    );
    return rows.map(MileageEntry.fromMap).toList();
  }

  /// Вставить запись. Если такая пара (mileage, recorded_at) уже есть,
  /// ничего не произойдёт (INSERT OR IGNORE).
  /// Возвращает количество вставленных строк (0 или 1).
  Future<int> insert(MileageEntry entry) async {
    return _db.insert(
      _table,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Удалить запись по паре (mileage, recorded_at).
  Future<void> delete(MileageEntry entry) async {
    await _db.delete(
      _table,
      where: 'mileage = ? AND recorded_at = ?',
      whereArgs: [entry.mileage, formatDateOnly(entry.recordedAt)],
    );
  }

  Future<bool> isEmpty() async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS c FROM $_table');
    return (Sqflite.firstIntValue(result) ?? 0) == 0;
  }
}
