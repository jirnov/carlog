// lib/data/models/settings.dart

import 'package:carlog/data/models/theme_mode_preference.dart';

/// Sentinel для `copyWith`, чтобы отличать «не передали» от «передали null».
const Object _unset = Object();

class Settings {
  const Settings({
    required this.carName,
    required this.remindEnabled,
    required this.remindDays,
    required this.yellowKm,
    required this.yellowMonths,
    required this.onboardingDone,
    required this.themeMode,
    required this.locale,
    required this.notificationsAsked,
  });

  final String carName;
  final bool remindEnabled;
  final int remindDays;
  final int yellowKm;
  final int yellowMonths;
  final bool onboardingDone;
  final ThemeModePreference themeMode;

  /// Язык приложения: `'ru'`, `'en'` или `null` — «как в системе».
  final String? locale;

  /// Спрашивали ли уже разрешение на уведомления при запуске.
  final bool notificationsAsked;

  static const defaults = Settings(
    carName: '',
    remindEnabled: true,
    remindDays: 30,
    yellowKm: 500,
    yellowMonths: 1,
    onboardingDone: false,
    themeMode: ThemeModePreference.system,
    locale: null,
    notificationsAsked: false,
  );

  factory Settings.fromMap(Map<String, Object?> map) {
    return Settings(
      carName: (map['car_name'] as String?) ?? '',
      remindEnabled: (map['remind_enabled'] as int? ?? 1) == 1,
      remindDays: (map['remind_days'] as int?) ?? 30,
      yellowKm: (map['yellow_km'] as int?) ?? 500,
      yellowMonths: (map['yellow_months'] as int?) ?? 1,
      onboardingDone: (map['onboarding_done'] as int? ?? 0) == 1,
      themeMode: ThemeModePreference.fromString(
        (map['theme_mode'] as String?) ?? 'system',
      ),
      locale: map['locale'] as String?,
      notificationsAsked: (map['notifications_asked'] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'car_name': carName,
      'remind_enabled': remindEnabled ? 1 : 0,
      'remind_days': remindDays,
      'yellow_km': yellowKm,
      'yellow_months': yellowMonths,
      'onboarding_done': onboardingDone ? 1 : 0,
      'theme_mode': themeMode.name,
      'locale': locale,
      'notifications_asked': notificationsAsked ? 1 : 0,
    };
  }

  Settings copyWith({
    String? carName,
    bool? remindEnabled,
    int? remindDays,
    int? yellowKm,
    int? yellowMonths,
    bool? onboardingDone,
    ThemeModePreference? themeMode,
    Object? locale = _unset,
    bool? notificationsAsked,
  }) {
    return Settings(
      carName: carName ?? this.carName,
      remindEnabled: remindEnabled ?? this.remindEnabled,
      remindDays: remindDays ?? this.remindDays,
      yellowKm: yellowKm ?? this.yellowKm,
      yellowMonths: yellowMonths ?? this.yellowMonths,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      themeMode: themeMode ?? this.themeMode,
      locale: identical(locale, _unset) ? this.locale : locale as String?,
      notificationsAsked: notificationsAsked ?? this.notificationsAsked,
    );
  }

  @override
  String toString() => 'Settings(carName: $carName, '
      'remindEnabled: $remindEnabled, remindDays: $remindDays, '
      'yellowKm: $yellowKm, yellowMonths: $yellowMonths, '
      'onboardingDone: $onboardingDone, themeMode: $themeMode, '
      'locale: $locale, notificationsAsked: $notificationsAsked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Settings &&
        other.carName == carName &&
        other.remindEnabled == remindEnabled &&
        other.remindDays == remindDays &&
        other.yellowKm == yellowKm &&
        other.yellowMonths == yellowMonths &&
        other.onboardingDone == onboardingDone &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.notificationsAsked == notificationsAsked;
  }

  @override
  int get hashCode => Object.hash(
        carName,
        remindEnabled,
        remindDays,
        yellowKm,
        yellowMonths,
        onboardingDone,
        themeMode,
        locale,
        notificationsAsked,
      );
}
