// test/helpers/db_helper.dart

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carlog/data/database.dart';

/// Подготовить in-memory БД для тестов.
///
/// Использование:
/// ```dart
/// late AppDatabase db;
///
/// setUpAll(() {
///   sqfliteFfiInit();
/// });
///
/// setUp(() async {
///   db = await openTestDatabase();
///   addTearDown(() => db.close());
/// });
/// ```
Future<AppDatabase> openTestDatabase() async {
  // AppDatabase — синглтон. Если уже открыта (от предыдущего теста),
  // сначала закрываем.
  final db = AppDatabase();
  if (db.isOpen) {
    await db.close();
  }
  await db.openInMemory(factory: databaseFactoryFfi);
  return db;
}