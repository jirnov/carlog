// integration_test/create_rule_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart';

Future<void> passOnboardingIfNeeded(WidgetTester tester) async {
  if (find.text('Добро пожаловать').evaluate().isNotEmpty) {
    await tester.enterText(
      find.widgetWithText(TextField, 'Название машины'),
      'Тестовая машина',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Текущий пробег'),
      '240000',
    );
    await tester.pump();

    await tester.tap(find.text('Продолжить'));

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('График работ пуст').evaluate().isNotEmpty) break;
    }
  }
}

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

/// Убрать фокус с поля → закрыть клавиатуру.
/// Безопаснее pageBack() — не трогает PopScope и не ищет BackButton.
Future<void> hideKeyboard(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('создание правила → выполнение → история', (tester) async {
    await runTestApp();

    await waitFor(tester, find.text('Добро пожаловать'));
    await passOnboardingIfNeeded(tester);

    await tester.tap(find.text('Планирование'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Своё'));
    await tester.pumpAndSettle();

    await waitFor(tester, find.text('Новое плановое ТО'));
    expect(find.text('Новое плановое ТО'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Название регламентной работы'),
      'Замена масла',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'На каком пробеге делать следующее ТО'),
      '250000',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'По км'),
      '10000',
    );
    await tester.pump();

    // Скрыть клавиатуру.
    await hideKeyboard(tester);

    await tester.tap(find.text('Сохранить'));
    await tester.pump(const Duration(milliseconds: 300));

    await waitForGone(tester, find.text('Новое плановое ТО'));

    await waitFor(tester, find.text('График работ'));
    await tester.tap(find.text('График работ'));
    await tester.pumpAndSettle();

    await waitFor(tester, find.text('Замена масла'));
    expect(find.text('Замена масла'), findsOneWidget);

    await tester.tap(find.text('[Выполнить]'));
    await tester.pumpAndSettle();

    await waitFor(tester, find.text('Выполнить работу'));
    expect(find.text('Выполнить работу'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Пробег выполнения'),
      '250000',
    );
    await tester.pump();

    // Скрыть клавиатуру.
    await hideKeyboard(tester);

    await tester.tap(find.text('Сохранить'));
    await tester.pump(const Duration(milliseconds: 300));

    await waitFor(tester, find.text('Обновить пробег машины?'));
    expect(find.text('Обновить пробег машины?'), findsOneWidget);

    await tester.tap(find.text('Да'));

    await waitFor(tester, find.textContaining('Замена масла выполнено'));
    expect(
      find.textContaining('Замена масла выполнено'),
      findsOneWidget,
    );

    await tester.tap(find.text('Выполнено'));
    await tester.pumpAndSettle();
    await waitFor(tester, find.text('Замена масла'));
    expect(find.text('Замена масла'), findsOneWidget);
  });
}
