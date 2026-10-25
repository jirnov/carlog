// lib/data/database.dart

import 'dart:ui' show PlatformDispatcher;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:carlog/data/dao/settings_dao.dart';
import 'package:carlog/data/dao/rules_dao.dart';
import 'package:carlog/data/dao/history_dao.dart';
import 'package:carlog/data/dao/mileage_dao.dart';
import 'package:carlog/data/dao/postponements_dao.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  factory AppDatabase() => instance;

  static const _dbName = 'carlog.db';

  /// Текущая версия схемы БД.
  /// Используется и в `ExportImportService` для `schema_version` в JSON.
  static const int currentVersion = 2;

  Database? _db;

  Database get db {
    final d = _db;
    if (d == null) {
      throw StateError('AppDatabase is not opened');
    }
    return d;
  }

  SettingsDao get settings => SettingsDao(db);
  RulesDao get rules => RulesDao(db);
  HistoryDao get history => HistoryDao(db);
  MileageDao get mileage => MileageDao(db);
  PostponementsDao get postponements => PostponementsDao(db);

  bool get isOpen => _db != null;

  Future<void> open() async {
    if (_db != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);

    _db = await _openAt(path);
  }

  Future<void> openInMemory({DatabaseFactory? factory}) async {
    if (_db != null) return;

    _db = await _openAt(inMemoryDatabasePath, factory: factory);
  }

  Future<Database> _openAt(String path, {DatabaseFactory? factory}) async {
    final options = OpenDatabaseOptions(
      version: currentVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    if (factory != null) {
      return factory.openDatabase(path, options: options);
    }
    return openDatabase(
      path,
      version: options.version,
      onConfigure: options.onConfigure,
      onCreate: options.onCreate,
      onUpgrade: options.onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE settings (
        id                    INTEGER PRIMARY KEY CHECK (id = 1),
        car_name              TEXT    NOT NULL DEFAULT '',
        remind_enabled        INTEGER NOT NULL DEFAULT 1,
        remind_days           INTEGER NOT NULL DEFAULT 30,
        yellow_km             INTEGER NOT NULL DEFAULT 500,
        yellow_months         INTEGER NOT NULL DEFAULT 1,
        onboarding_done       INTEGER NOT NULL DEFAULT 0,
        theme_mode            TEXT    NOT NULL DEFAULT 'system',
        locale                TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE rules (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        title           TEXT    NOT NULL,
        note            TEXT    NOT NULL DEFAULT '',
        next_km         INTEGER,
        next_date       TEXT,
        interval_km     INTEGER,
        interval_months INTEGER,
        cost            REAL
      )
    ''');

    batch.execute('''
      CREATE TABLE history (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        title        TEXT    NOT NULL,
        note         TEXT    NOT NULL DEFAULT '',
        mileage      INTEGER NOT NULL,
        performed_at TEXT    NOT NULL,
        cost         REAL
      )
    ''');

    batch.execute('''
      CREATE TABLE mileage_log (
        mileage     INTEGER NOT NULL,
        recorded_at TEXT    NOT NULL,
        PRIMARY KEY (mileage, recorded_at)
      )
    ''');

    batch.execute('''
      CREATE TABLE postponements (
        rule_id    INTEGER PRIMARY KEY
                   REFERENCES rules(id) ON DELETE CASCADE,
        until_date TEXT    NOT NULL,
        created_at TEXT    NOT NULL
      )
    ''');

    batch.execute(
        'CREATE INDEX idx_history_performed ON history(performed_at DESC)');
    batch.execute(
        'CREATE INDEX idx_mileage_recorded ON mileage_log(recorded_at DESC)');

    batch.insert('settings', {
      'id': 1,
      'car_name': '',
      'remind_enabled': 1,
      'remind_days': 30,
      'yellow_km': 500,
      'yellow_months': 1,
      'onboarding_done': 0,
      'theme_mode': 'system',
      'locale': null,
    });

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE settings ADD COLUMN locale TEXT');

      final systemLang =
          PlatformDispatcher.instance.locale.languageCode.toLowerCase();
      final initialLocale = systemLang == 'ru' ? 'ru' : 'en';

      await db.update(
        'settings',
        {'locale': initialLocale},
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
