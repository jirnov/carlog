// lib/providers/postponements_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/postponement.dart';
import 'package:carlog/utils/formatting.dart';

class PostponementsProvider extends ChangeNotifier {
  PostponementsProvider(this._db);

  final AppDatabase _db;

  List<Postponement> _items = [];
  bool _disposed = false;

  List<Postponement> get items => _items;

  Future<void> load() async {
    _items = await _db.postponements.getAll();
    _notify();
  }

  Future<void> reload() => load();

  /// Отложить правило до указанной даты.
  /// Если отложка уже была — перезаписывается.
  Future<void> postponeRule(int ruleId, DateTime untilDate) async {
    final today = dateOnly(DateTime.now());
    final until = dateOnly(untilDate);

    if (!until.isAfter(today) && !until.isAtSameMomentAs(today)) {
      throw ArgumentError('Дата отложки должна быть в будущем');
    }

    await _db.postponements.save(Postponement(
      ruleId: ruleId,
      untilDate: until,
      createdAt: today,
    ));
    await load();
  }

  /// Удалить отложку (используется при выполнении ТО).
  Future<void> removeForRule(int ruleId) async {
    await _db.postponements.removeForRule(ruleId);
    await load();
  }

  Postponement? forRule(int ruleId) {
    for (final p in _items) {
      if (p.ruleId == ruleId) return p;
    }
    return null;
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
