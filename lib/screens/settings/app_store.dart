// lib/screens/settings/app_store.dart

import 'package:flutter/services.dart';

/// Магазин приложений, из которого установлена сборка.
/// Определяется по flavor (`--flavor googleplay` / `--flavor rustore`).
enum AppStore {
  none,
  googlePlay,
  rustore;

  static AppStore fromName(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'googleplay':
        return AppStore.googlePlay;
      case 'rustore':
        return AppStore.rustore;
      default:
        return AppStore.none;
    }
  }

  String? get url {
    switch (this) {
      case AppStore.googlePlay:
        return 'https://play.google.com/store/apps/details?id=ru.blog2k.carlog';
      case AppStore.rustore:
        return 'https://www.rustore.ru/catalog/app/ru.blog2k.carlog';
      case AppStore.none:
        return null;
    }
  }
}

/// Текущий магазин. `appFlavor` задаётся Flutter на этапе компиляции.
final String _kFlavor = appFlavor ?? '';
final AppStore kCurrentStore = AppStore.fromName(_kFlavor);
final String? kStoreUrl = kCurrentStore.url;

/// Ссылка на донат.
const String kCoffeeUrl = 'https://pay.cloudtips.ru/p/31704978';
