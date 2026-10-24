// lib/screens/main/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carlog/l10n/context_l10n.dart';
import 'package:carlog/screens/history/history_screen.dart';
import 'package:carlog/screens/home/home_screen.dart';
import 'package:carlog/screens/rules/rules_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  /// Ключ к HomeScreen — чтобы управлять режимом выбора.
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  /// Время последнего нажатия Back (для двойного нажатия).
  DateTime? _lastBackPress;

  /// Окно, в течение которого второе нажатие считается «выходом».
  static const _exitWindow = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final screens = [
      HomeScreen(key: _homeKey),
      const RulesScreen(),
      const HistoryScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            if (i == _currentIndex) return;
            setState(() => _currentIndex = i);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.navSchedule,
            ),
            NavigationDestination(
              icon: const Icon(Icons.build_outlined),
              selectedIcon: const Icon(Icons.build),
              label: l10n.navPlanning,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              label: l10n.navHistory,
            ),
          ],
        ),
      ),
    );
  }

  void _handleBack() {
    // Если HomeScreen в режиме выбора — снять выделение.
    final homeState = _homeKey.currentState;
    if (homeState != null && homeState.isSelectionMode) {
      homeState.exitSelectionMode();
      return;
    }

    // Иначе — двойное нажатие для выхода.
    final now = DateTime.now();

    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > _exitWindow) {
      _lastBackPress = now;

      final l10n = context.l10n;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.exitConfirmMessage),
            duration: _exitWindow,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    SystemNavigator.pop();
  }
}
