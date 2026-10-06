// lib/providers/history_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/history_record.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider(this._db);

  final AppDatabase _db;

  List<HistoryRecord> _records = [];
  bool _disposed = false;

  List<HistoryRecord> get records => _records;

  Future<void> load() async {
    _records = await _db.history.getAll();
    _notify();
  }

  Future<void> reload() => load();

  Future<void> add(HistoryRecord record) async {
    await _db.history.insert(record);
    await load();
  }

  Future<void> update(HistoryRecord record) async {
    await _db.history.update(record);
    await load();
  }

  Future<void> remove(int id) async {
    await _db.history.delete(id);
    await load();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
