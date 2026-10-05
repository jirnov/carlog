// lib/screens/app_root.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:carlog/providers/settings_provider.dart';
import 'package:carlog/screens/main/main_screen.dart';
import 'package:carlog/screens/onboarding/onboarding_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingDone = context.select<SettingsProvider, bool>(
      (p) => p.onboardingDone,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: onboardingDone
          ? const MainScreen(key: ValueKey('main'))
          : const OnboardingScreen(key: ValueKey('onboarding')),
    );
  }
}