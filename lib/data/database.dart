// lib/data/database.dart

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/dao/settings_dao.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  factory AppDatabase() => instance;

  static const _dbName = 'carlog.db';
  static const _currentVersion = 1;

  Database? _db;

  Database get db {
    final d = _db;
    if (d == null) {
      throw StateError('AppDatabase не открыта. Вызовите open() в main().');
    }
    return d;
  }

  late final SettingsDao settings = SettingsDao(db);

  bool get isOpen => _db != null;

  Future<void> open() async {
    if (_db != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);

    _db = await openDatabase(
      path,
      version: _currentVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE settings (
        id              INTEGER PRIMARY KEY CHECK (id = 1),
        car_name        TEXT    NOT NULL DEFAULT '',
        remind_enabled  INTEGER NOT NULL DEFAULT 1,
        remind_days     INTEGER NOT NULL DEFAULT 7,
        yellow_km       INTEGER NOT NULL DEFAULT 500,
        yellow_months   INTEGER NOT NULL DEFAULT 1,
        onboarding_done INTEGER NOT NULL DEFAULT 0
      )
    ''');

    batch.insert('settings', {
      'id': 1,
      'car_name': '',
      'remind_enabled': 1,
      'remind_days': 7,
      'yellow_km': 500,
      'yellow_months': 1,
      'onboarding_done': 0,
    });

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Миграции при обновлении версии схемы.
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}