// lib/data/dao/mileage_dao.dart
import 'package:sqflite/sqflite.dart';
import '../models/mileage_entry.dart';

class MileageDao {
  MileageDao(this._db);
  final Database _db;

  static const _table = 'mileage_log';

  /// Вся история, от новых к старым.
  Future<List<MileageEntry>> getAll() async {
    final rows = await _db.query(_table, orderBy: 'recorded_at DESC');
    return rows.map(MileageEntry.fromMap).toList();
  }

  /// Текущий пробег — последняя запись. null, если записей ещё нет.
  Future<MileageEntry?> getCurrent() async {
    final rows = await _db.query(
      _table,
      orderBy: 'recorded_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MileageEntry.fromMap(rows.first);
  }

  /// Первая запись — начало учёта. Используется, если у правила нет
  /// записей истории и base_mode = auto.
  Future<MileageEntry?> getFirst() async {
    final rows = await _db.query(
      _table,
      orderBy: 'recorded_at ASC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MileageEntry.fromMap(rows.first);
  }

  /// Последние N записей — для расчёта среднесуточного темпа.
  Future<List<MileageEntry>> getLast(int limit) async {
    final rows = await _db.query(
      _table,
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return rows.map(MileageEntry.fromMap).toList();
  }

  /// Вставить запись о пробеге.
  Future<int> insert(int mileage, DateTime recordedAt) async {
    return _db.insert(_table, {
      'mileage': mileage,
      'recorded_at': recordedAt.toIso8601String(),
    });
  }

  /// Удалить запись — на случай опечатки при вводе.
  Future<void> delete(int id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Есть ли записи вообще. Для проверки на пустой журнал.
  Future<bool> isEmpty() async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS c FROM $_table');
    return (Sqflite.firstIntValue(result) ?? 0) == 0;
  }
}