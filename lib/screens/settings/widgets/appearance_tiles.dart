// lib/screens/settings/widgets/appearance_tiles.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/data/models/theme_mode_preference.dart';
import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/providers/settings_provider.dart';

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key});

  String _label(BuildContext context, ThemeModePreference pref) {
    final l10n = context.l10n;
    switch (pref) {
      case ThemeModePreference.system:
        return l10n.themeSystem;
      case ThemeModePreference.light:
        return l10n.themeLight;
      case ThemeModePreference.dark:
        return l10n.themeDark;
    }
  }

  Future<void> _pick(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    final current = provider.themeModePreference;

    final result = await showDialog<ThemeModePreference>(
      context: context,
      builder: (dialogContext) {
        var selected = current;
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: Text(l10n.themeDialogTitle),
            children: [
              RadioGroup<ThemeModePreference>(
                groupValue: selected,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selected = value);
                  Navigator.of(dialogContext).pop(value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final pref in ThemeModePreference.values)
                      RadioListTile<ThemeModePreference>(
                        value: pref,
                        title: Text(_label(context, pref)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && context.mounted) {
      await provider.setThemeMode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pref = context.select<SettingsProvider, ThemeModePreference>(
      (p) => p.themeModePreference,
    );

    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(l10n.settingsThemeTitle),
      subtitle: Text(_label(context, pref)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pick(context),
    );
  }
}

class LocaleTile extends StatelessWidget {
  const LocaleTile({super.key});

  String _label(BuildContext context, String? locale) {
    final l10n = context.l10n;
    switch (locale) {
      case 'ru':
        return l10n.languageRussian;
      case 'en':
        return l10n.languageEnglish;
      default:
        return l10n.languageSystem;
    }
  }

  Future<void> _pick(BuildContext context) async {
    final l10n = context.l10n;
    final provider = context.read<SettingsProvider>();
    final current = provider.locale;

    // Оборачиваем результат в record, чтобы отличить «диалог закрыт»
    // (result == null) от «выбран System» (result != null, locale == null).
    final result = await showDialog<({String? locale})>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.languageDialogTitle),
        children: [
          RadioGroup<String?>(
            groupValue: current,
            onChanged: (value) =>
                Navigator.of(dialogContext).pop((locale: value)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String?>(
                  value: null,
                  title: Text(l10n.languageSystem),
                ),
                RadioListTile<String?>(
                  value: 'ru',
                  title: Text(l10n.languageRussian),
                ),
                RadioListTile<String?>(
                  value: 'en',
                  title: Text(l10n.languageEnglish),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (context.mounted && result != null) {
      await provider.setLocale(result.locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.select<SettingsProvider, String?>((p) => p.locale);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.languageTitle),
      subtitle: Text(_label(context, locale)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pick(context),
    );
  }
}
