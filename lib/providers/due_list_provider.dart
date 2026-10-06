// lib/providers/due_list_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/providers/history_provider.dart';
import 'package:carlog/providers/mileage_provider.dart';
import 'package:carlog/providers/postponements_provider.dart';
import 'package:carlog/providers/rules_provider.dart';
import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/services/maintenance_service.dart';

/// Провайдер карточек ТО на главном экране.
class DueListProvider extends ChangeNotifier {
  DueListProvider(
    AppDatabase db, {
    required MileageProvider mileage,
    required RulesProvider rules,
    required HistoryProvider history,
    required SettingsProvider settings,
    required PostponementsProvider postponements,
  })  : _mileage = mileage,
        _rules = rules,
        _history = history,
        _settings = settings,
        _postponements = postponements,
        _service = MaintenanceService(db) {
    _mileage.addListener(_onDataChanged);
    _rules.addListener(_onDataChanged);
    _history.addListener(_onDataChanged);
    _settings.addListener(_onDataChanged);
    _postponements.addListener(_onDataChanged);

    _load();
  }

  final MaintenanceService _service;
  final MileageProvider _mileage;
  final RulesProvider _rules;
  final HistoryProvider _history;
  final SettingsProvider _settings;
  final PostponementsProvider _postponements;

  List<DueInfo> _items = [];
  List<DueInfo> get items => _items;

  List<DueInfo> get active => _items.where((d) => !d.isPostponed).toList();

  List<DueInfo> get postponed => _items.where((d) => d.isPostponed).toList();

  DueInfo? get nearest {
    final a = active;
    return a.isEmpty ? null : a.first;
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void _onDataChanged() {
    _load();
  }

  Future<void> _load() async {
    final result = await _service.dueList();
    _items = result;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> reload() => _load();

  @override
  void dispose() {
    _mileage.removeListener(_onDataChanged);
    _rules.removeListener(_onDataChanged);
    _history.removeListener(_onDataChanged);
    _settings.removeListener(_onDataChanged);
    _postponements.removeListener(_onDataChanged);
    super.dispose();
  }
}
