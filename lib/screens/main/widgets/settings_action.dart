// lib/screens/main/widgets/settings_action.dart

import 'package:flutter/material.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/screens/settings/settings_screen.dart';

/// Кнопка «Настройки» для AppBar. Открывает SettingsScreen.
class SettingsAction extends StatelessWidget {
  const SettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: l10n.settingsTooltip,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SettingsScreen(),
          ),
        );
      },
    );
  }
}
