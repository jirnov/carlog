// lib/providers/settings_provider.dart

import 'package:flutter/foundation.dart';

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._db) {
    _load();
  }

  final AppDatabase _db;

  Settings _settings = Settings.defaults;

  Settings get settings => _settings;

  String get carName => _settings.carName;
  bool get remindEnabled => _settings.remindEnabled;
  int get remindDays => _settings.remindDays;
  int get yellowKm => _settings.yellowKm;
  int get yellowMonths => _settings.yellowMonths;
  bool get onboardingDone => _settings.onboardingDone;

  Future<void> _load() async {
    _settings = await _db.settings.get();
    notifyListeners();
  }

  Future<void> reload() => _load();

  Future<void> setCarName(String value) async {
    if (_settings.carName == value) return;
    await _db.settings.setCarName(value);
    _settings = _settings.copyWith(carName: value);
    notifyListeners();
  }

  Future<void> setRemindEnabled(bool value) async {
    if (_settings.remindEnabled == value) return;
    await _db.settings.setRemindEnabled(value);
    _settings = _settings.copyWith(remindEnabled: value);
    notifyListeners();
  }

  Future<void> setRemindDays(int value) async {
    if (_settings.remindDays == value) return;
    await _db.settings.setRemindDays(value);
    _settings = _settings.copyWith(remindDays: value);
    notifyListeners();
  }

  Future<void> setYellowKm(int value) async {
    if (_settings.yellowKm == value) return;
    await _db.settings.setYellowKm(value);
    _settings = _settings.copyWith(yellowKm: value);
    notifyListeners();
  }

  Future<void> setYellowMonths(int value) async {
    if (_settings.yellowMonths == value) return;
    await _db.settings.setYellowMonths(value);
    _settings = _settings.copyWith(yellowMonths: value);
    notifyListeners();
  }

  Future<void> setOnboardingDone(bool value) async {
    if (_settings.onboardingDone == value) return;
    await _db.settings.setOnboardingDone(value);
    _settings = _settings.copyWith(onboardingDone: value);
    notifyListeners();
  }
}