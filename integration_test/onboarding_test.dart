// integration_test/onboarding_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('онбординг → главный', (tester) async {
    await runTestApp();

    // Ждём, пока SplashScreen загрузит данные и переключится на AppRoot.
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('Добро пожаловать').evaluate().isNotEmpty) break;
    }

    expect(find.text('Добро пожаловать'), findsOneWidget);
    expect(find.text('Название машины'), findsOneWidget);
    expect(find.text('Текущий пробег'), findsOneWidget);

    // Вводим данные.
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

    // Ждём перехода на главный.
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('График работ пуст').evaluate().isNotEmpty) break;
    }

    expect(find.text('График работ пуст'), findsOneWidget);
    expect(find.text('Тестовая машина'), findsOneWidget);
  });
}
