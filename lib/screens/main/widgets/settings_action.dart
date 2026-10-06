// lib/screens/main/widgets/settings_action.dart

import 'package:flutter/material.dart';

import 'package:carlog/screens/settings/settings_screen.dart';

/// Кнопка «Настройки» для AppBar. Открывает SettingsScreen.
class SettingsAction extends StatelessWidget {
  const SettingsAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Настройки',
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