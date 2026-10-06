// test/data/dao/rules_dao_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/rule.dart';

void main() {
  late AppDatabase db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = AppDatabase();
    if (db.isOpen) await db.close();
    await db.openInMemory(factory: databaseFactoryFfi);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertRule(Rule rule) => db.rules.insert(rule);

  Future<Rule> getRule(int id) async {
    final r = await db.rules.getById(id);
    expect(r, isNotNull);
    return r!;
  }

  group('RulesDao.advance — next_km', () {
    test('выполнили ровно в срок → next_km = performed + interval', () async {
      final id = await insertRule(const Rule(
        title: 'Масло',
        nextKm: 240000,
        intervalKm: 10000,
      ));

      await db.rules.advance(
        id,
        performedMileage: 240000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 250000);
    });

    test('досрочное выполнение → next_km = performed + interval', () async {
      final id = await insertRule(const Rule(
        title: 'Масло',
        nextKm: 240000,
        intervalKm: 10000,
      ));

      await db.rules.advance(
        id,
        performedMileage: 235000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 245000);
    });

    test('просрочка → next_km = performed + interval', () async {
      final id = await insertRule(const Rule(
        title: 'Масло',
        nextKm: 240000,
        intervalKm: 10000,
      ));

      await db.rules.advance(
        id,
        performedMileage: 255000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 265000);
    });
  });

  group('RulesDao.advance — next_date', () {
    test('выполнили ровно в срок → next_date = performed + interval', () async {
      final id = await insertRule(Rule(
        title: 'Масло',
        nextDate: DateTime(2026, 10, 15),
        intervalMonths: 12,
      ));

      await db.rules.advance(
        id,
        performedMileage: 240000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextDate, DateTime(2027, 10, 15));
    });

    test('досрочное выполнение → next_date = performed + interval', () async {
      final id = await insertRule(Rule(
        title: 'Масло',
        nextDate: DateTime(2027, 10, 15),
        intervalMonths: 12,
      ));

      await db.rules.advance(
        id,
        performedMileage: 240000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextDate, DateTime(2027, 10, 15));
    });
  });

  group('RulesDao.advance — только один интервал', () {
    test('только км → next_date не меняется', () async {
      final id = await insertRule(const Rule(
        title: 'Колодки',
        nextKm: 30000,
        intervalKm: 30000,
      ));

      await db.rules.advance(
        id,
        performedMileage: 30000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 60000);
      expect(r.nextDate, isNull);
    });

    test('только месяцы → next_km не меняется', () async {
      final id = await insertRule(Rule(
        title: 'Антифриз',
        nextKm: 60000,
        nextDate: DateTime(2026, 10, 15),
        intervalMonths: 60,
      ));

      await db.rules.advance(
        id,
        performedMileage: 65000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 60000);
      expect(r.nextDate, DateTime(2031, 10, 15));
    });

    test('нет интервалов → ничего не меняется', () async {
      final id = await insertRule(const Rule(
        title: 'Без интервалов',
        nextKm: 100000,
      ));

      await db.rules.advance(
        id,
        performedMileage: 100000,
        performedDate: DateTime(2026, 10, 15),
      );

      final r = await getRule(id);
      expect(r.nextKm, 100000);
      expect(r.nextDate, isNull);
    });
  });
}