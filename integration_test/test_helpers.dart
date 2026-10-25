// integration_test/test_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Пройти онбординг, если он ещё не пройден.
Future<void> passOnboardingIfNeeded(WidgetTester tester) async {
  if (find.text('Welcome').evaluate().isNotEmpty) {
    await tester.enterText(
      find.widgetWithText(TextField, 'Car name'),
      'Test car',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Current mileage'),
      '240000',
    );
    await tester.pump();

    await tester.tap(find.text('Continue'));

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('Work schedule is empty').evaluate().isNotEmpty) break;
    }
  }
}

/// Дождаться появления виджета.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  int maxIterations = 20,
}) async {
  for (int i = 0; i < maxIterations; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (finder.evaluate().isNotEmpty) return;
  }
}

/// Дождаться исчезновения виджета.
Future<void> waitForGone(
  WidgetTester tester,
  Finder finder, {
  int maxIterations = 20,
}) async {
  for (int i = 0; i < maxIterations; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (finder.evaluate().isEmpty) return;
  }
}

/// Скрыть клавиатуру — снимаем фокус и даём время клавиатуре уйти.
Future<void> hideKeyboard(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 500));
}

/// Тап по кнопке с предварительной прокруткой до неё.
Future<void> tapButton(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 300));
}

/// Создать правило через UI (вкладка «Planning» → FAB → «Custom»).
///
/// Если правило с таким именем уже есть — ничего не делает.
Future<void> createRuleIfNeeded(
  WidgetTester tester, {
  required String name,
  required String nextKm,
  required String intervalKm,
}) async {
  await tester.tap(find.text('Planning'));
  await tester.pumpAndSettle();

  if (find.text(name).evaluate().isNotEmpty) return;

  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Custom'));
  await tester.pumpAndSettle();

  await waitFor(tester, find.text('New scheduled maintenance'));

  await tester.enterText(
    find.widgetWithText(TextField, 'Name of scheduled work'),
    name,
  );
  await tester.enterText(
    find.widgetWithText(
      TextField,
      'At what mileage to do the next maintenance',
    ),
    nextKm,
  );
  await tester.enterText(
    find.widgetWithText(TextField, 'By km'),
    intervalKm,
  );
  await tester.pump();

  await hideKeyboard(tester);
  await tapButton(tester, find.text('Save'));
  await waitForGone(tester, find.text('New scheduled maintenance'));
}

/// Перейти на вкладку «Work schedule» (главный экран).
Future<void> goToSchedule(WidgetTester tester) async {
  await waitFor(tester, find.text('Work schedule'));
  await tester.tap(find.text('Work schedule'));
  await tester.pumpAndSettle();
}
