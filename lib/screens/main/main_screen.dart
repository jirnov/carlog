// lib/screens/main/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  /// Время последнего нажатия Back (для двойного нажатия).
  DateTime? _lastBackPress;

  /// Окно, в течение которого второе нажатие считается «выходом».
  static const _exitWindow = Duration(seconds: 2);

  static const List<Widget> _screens = [
    HomeScreen(),
    RulesScreen(),
    HistoryScreen(),
  ];

  void _handleBack() {
    final now = DateTime.now();

    // Первое нажатие или прошло больше окна — показать подсказку.
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > _exitWindow) {
      _lastBackPress = now;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Нажмите ещё раз для выхода'),
            duration: _exitWindow,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    // Второе нажатие в течение окна — выход.
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            if (i == _currentIndex) return;
            setState(() => _currentIndex = i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'График работ',
            ),
            NavigationDestination(
              icon: Icon(Icons.build_outlined),
              selectedIcon: Icon(Icons.build),
              label: 'Планирование',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Выполнено',
            ),
          ],
        ),
      ),
    );
  }
}
