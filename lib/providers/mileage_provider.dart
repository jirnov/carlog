// lib/providers/mileage_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/mileage_entry.dart';
import 'package:carlog/utils/formatting.dart';

class MileageProvider extends ChangeNotifier {
  MileageProvider(this._db);

  final AppDatabase _db;

  List<MileageEntry> _entries = [];
  int _currentMileage = 0;
  DateTime? _lastUpdatedAt;
  bool _isLoading = true;
  bool _disposed = false;

  List<MileageEntry> get entries => _entries;
  int get currentMileage => _currentMileage;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  bool get isLoading => _isLoading;
  bool get hasMileage => _entries.isNotEmpty;

  int? get daysSinceUpdate {
    if (_lastUpdatedAt == null) return null;
    final today = dateOnly(DateTime.now());
    final updated = dateOnly(_lastUpdatedAt!);
    return today.difference(updated).inDays;
  }

  /// Загрузить историю из БД.
  /// Вызывается вручную из main.dart и из тестов.
  Future<void> load() async {
    _entries = await _db.mileage.getAll();

    final current = _entries.isEmpty
        ? null
        : _entries.reduce((a, b) => a.mileage >= b.mileage ? a : b);
    _currentMileage = current?.mileage ?? 0;
    _lastUpdatedAt = _entries.isEmpty ? null : _entries.first.recordedAt;

    _isLoading = false;
    _notify();
  }

  /// Перечитать историю.
  Future<void> reload() => load();

  Future<void> add(int mileage) async {
    await _db.mileage.insert(MileageEntry(
      mileage: mileage,
      recordedAt: DateTime.now(),
    ));
    await load();
  }

  Future<void> remove(MileageEntry entry) async {
    await _db.mileage.delete(entry);
    await load();
  }

  /// Безопасный вызов notifyListeners — не падает после dispose.
  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
