// lib/providers/settings_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import 'package:carlog/data/database.dart';
import 'package:carlog/data/models/settings.dart';
import 'package:carlog/data/models/theme_mode_preference.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._db);

  final AppDatabase _db;

  Settings _settings = Settings.defaults;
  bool _disposed = false;

  Settings get settings => _settings;

  String get carName => _settings.carName;
  bool get remindEnabled => _settings.remindEnabled;
  int get remindDays => _settings.remindDays;
  int get yellowKm => _settings.yellowKm;
  int get yellowMonths => _settings.yellowMonths;
  bool get onboardingDone => _settings.onboardingDone;

  ThemeModePreference get themeModePreference => _settings.themeMode;
  ThemeMode get themeMode => _settings.themeMode.toFlutter();

  /// Язык приложения: `'ru'`, `'en'` или `null` — «как в системе».
  String? get locale => _settings.locale;

  /// Спрашивали ли уже разрешение на уведомления при запуске.
  bool get notificationsAsked => _settings.notificationsAsked;

  Future<void> load() async {
    _settings = await _db.settings.get();
    _notify();
  }

  Future<void> reload() => load();

  Future<void> setCarName(String value) async {
    if (_settings.carName == value) return;
    await _db.settings.setCarName(value);
    _settings = _settings.copyWith(carName: value);
    _notify();
  }

  Future<void> setRemindEnabled(bool value) async {
    if (_settings.remindEnabled == value) return;
    await _db.settings.setRemindEnabled(value);
    _settings = _settings.copyWith(remindEnabled: value);
    _notify();
  }

  Future<void> setRemindDays(int value) async {
    if (_settings.remindDays == value) return;
    await _db.settings.setRemindDays(value);
    _settings = _settings.copyWith(remindDays: value);
    _notify();
  }

  Future<void> setYellowKm(int value) async {
    if (_settings.yellowKm == value) return;
    await _db.settings.setYellowKm(value);
    _settings = _settings.copyWith(yellowKm: value);
    _notify();
  }

  Future<void> setYellowMonths(int value) async {
    if (_settings.yellowMonths == value) return;
    await _db.settings.setYellowMonths(value);
    _settings = _settings.copyWith(yellowMonths: value);
    _notify();
  }

  Future<void> setOnboardingDone(bool value) async {
    if (_settings.onboardingDone == value) return;
    await _db.settings.setOnboardingDone(value);
    _settings = _settings.copyWith(onboardingDone: value);
    _notify();
  }

  Future<void> setThemeMode(ThemeModePreference value) async {
    if (_settings.themeMode == value) return;
    await _db.settings.setThemeMode(value);
    _settings = _settings.copyWith(themeMode: value);
    _notify();
  }

  Future<void> setLocale(String? value) async {
    if (_settings.locale == value) return;
    await _db.settings.setLocale(value);
    _settings = _settings.copyWith(locale: value);
    _notify();
  }

  Future<void> setNotificationsAsked(bool value) async {
    if (_settings.notificationsAsked == value) return;
    await _db.settings.setNotificationsAsked(value);
    _settings = _settings.copyWith(notificationsAsked: value);
    _notify();
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
