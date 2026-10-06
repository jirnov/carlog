// lib/providers/rules_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/rule.dart';

class RulesProvider extends ChangeNotifier {
  RulesProvider(this._db);

  final AppDatabase _db;

  List<Rule> _rules = [];
  bool _disposed = false;

  List<Rule> get rules => _rules;

  Future<void> load() async {
    _rules = await _db.rules.getAll();
    _notify();
  }

  Future<void> reload() => load();

  Future<void> add(Rule rule) async {
    await _db.rules.insert(rule);
    await load();
  }

  Future<void> update(Rule rule) async {
    await _db.rules.update(rule);
    await load();
  }

  /// Сдвинуть следующее ТО после выполнения.
  ///
  /// И км, и дата считаются строго от факта выполнения:
  /// `next_km = performedMileage + interval_km`,
  /// `next_date = performedDate + interval_months`.
  Future<void> advance(
    int ruleId, {
    required int performedMileage,
    required DateTime performedDate,
  }) async {
    await _db.rules.advance(
      ruleId,
      performedMileage: performedMileage,
      performedDate: performedDate,
    );
    await load();
  }

  Future<void> remove(int id) async {
    await _db.rules.delete(id);
    await load();
  }

  Rule? byId(int id) {
    for (final r in _rules) {
      if (r.id == id) return r;
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
