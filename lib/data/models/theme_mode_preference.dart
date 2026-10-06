// lib/data/models/theme_mode_preference.dart

import 'package:flutter/material.dart';

/// Пользовательский выбор темы. В БД хранится строкой.
enum ThemeModePreference {
  system,
  light,
  dark;

  static ThemeModePreference fromString(String value) {
    return ThemeModePreference.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeModePreference.system,
    );
  }

  /// Преобразовать в Flutter-овый ThemeMode для MaterialApp.
  ThemeMode toFlutter() {
    switch (this) {
      case ThemeModePreference.system:
        return ThemeMode.system;
      case ThemeModePreference.light:
        return ThemeMode.light;
      case ThemeModePreference.dark:
        return ThemeMode.dark;
    }
  }
}
