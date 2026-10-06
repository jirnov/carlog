// test/services/history_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/history_record.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/screens/mark_done/mark_done_screen.dart';
import 'package:carlog/services/history_service.dart';

void main() {
  late AppDatabase db;
  late HistoryProvider history;
  late MileageProvider mileage;
  const service = HistoryService();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = AppDatabase();
    if (db.isOpen) await db.close();
    await db.openInMemory(factory: databaseFactoryFfi);

    history = HistoryProvider(db);
    mileage = MileageProvider(db);

    await history.load();
    await mileage.load();
  });

  tearDown(() async {
    await db.close();
  });

  MarkDoneResult makeResult({
    int mileageValue = 240000,
    DateTime? performedAt,
    int? updatedMileage,
  }) {
    return MarkDoneResult(
      record: HistoryRecord(
        title: 'Масло',
        note: '',
        mileage: mileageValue,
        performedAt: performedAt ?? DateTime(2026, 10, 15),
      ),
      updatedMileage: updatedMileage,
    );
  }

  group('applyMarkDoneFromHome', () {
    test('пишет запись в историю', () async {
      final result = makeResult(mileageValue: 240000);

      await service.applyMarkDoneFromHome(
        result: result,
        history: history,
        mileage: mileage,
      );

      expect(history.records.length, 1);
      expect(history.records.first.title, 'Масло');
      expect(history.records.first.mileage, 240000);
      expect(history.records.first.performedAt, DateTime(2026, 10, 15));
    });

    test('обновляет mileage, если updatedMileage задан', () async {
      final result = makeResult(
        mileageValue: 245000,
        updatedMileage: 245000,
      );

      await service.applyMarkDoneFromHome(
        result: result,
        history: history,
        mileage: mileage,
      );

      expect(mileage.currentMileage, 245000);
    });

    test('НЕ обновляет mileage, если updatedMileage == null', () async {
      // Сначала зададим текущий пробег.
      await mileage.add(240000);
      expect(mileage.currentMileage, 240000);

      final result = makeResult(
        mileageValue: 240000,
        updatedMileage: null,
      );

      await service.applyMarkDoneFromHome(
        result: result,
        history: history,
        mileage: mileage,
      );

      // Пробег не изменился.
      expect(mileage.currentMileage, 240000);
    });

    test('история и пробег обновляются независимо', () async {
      final result = makeResult(
        mileageValue: 245000,
        updatedMileage: 245000,
      );

      await service.applyMarkDoneFromHome(
        result: result,
        history: history,
        mileage: mileage,
      );

      expect(history.records.length, 1);
      expect(mileage.currentMileage, 245000);
    });
  });

  group('applyManualHistoryAdd', () {
    test('пишет запись в историю', () async {
      final result = makeResult(mileageValue: 230000);

      await service.applyManualHistoryAdd(
        result: result,
        history: history,
      );

      expect(history.records.length, 1);
      expect(history.records.first.mileage, 230000);
    });

    test('НЕ обновляет mileage', () async {
      await mileage.add(240000);

      final result = makeResult(
        mileageValue: 230000,
        updatedMileage: 230000, // ← игнорируется в applyManualHistoryAdd
      );

      await service.applyManualHistoryAdd(
        result: result,
        history: history,
      );

      expect(mileage.currentMileage, 240000);
    });
  });

  group('applyHistoryUpdate', () {
    test('перезаписывает запись', () async {
      // Создаём запись.
      final initial = HistoryRecord(
        title: 'Масло',
        note: '',
        mileage: 240000,
        performedAt: DateTime(2026, 10, 15),
      );
      await history.add(initial);
      final savedId = history.records.first.id!;

      // Обновляем.
      final updated = HistoryRecord(
        id: savedId,
        title: 'Масло',
        note: 'Teboil',
        mileage: 245000,
        performedAt: DateTime(2026, 11, 15),
      );

      await service.applyHistoryUpdate(
        result: MarkDoneResult(record: updated, updatedMileage: null),
        history: history,
      );

      expect(history.records.length, 1);
      expect(history.records.first.id, savedId);
      expect(history.records.first.mileage, 245000);
      expect(history.records.first.note, 'Teboil');
      expect(history.records.first.performedAt, DateTime(2026, 11, 15));
    });

    test('НЕ обновляет mileage', () async {
      await mileage.add(240000);

      final initial = HistoryRecord(
        title: 'Масло',
        note: '',
        mileage: 240000,
        performedAt: DateTime(2026, 10, 15),
      );
      await history.add(initial);
      final savedId = history.records.first.id!;

      final updated = HistoryRecord(
        id: savedId,
        title: 'Масло',
        note: '',
        mileage: 250000, // ← другое значение
        performedAt: DateTime(2026, 10, 15),
      );

      await service.applyHistoryUpdate(
        result: MarkDoneResult(record: updated, updatedMileage: 250000),
        history: history,
      );

      // Пробег машины не изменился.
      expect(mileage.currentMileage, 240000);
      // История обновилась.
      expect(history.records.first.mileage, 250000);
    });
  });
}