// integration_test/onboarding_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart';
import 'test_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('onboarding → main', (tester) async {
    await runTestApp();

    await waitFor(tester, find.text('Welcome'));

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Car name'), findsOneWidget);
    expect(find.text('Current mileage'), findsOneWidget);

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

    await waitFor(tester, find.text('Work schedule is empty'));

    expect(find.text('Work schedule is empty'), findsOneWidget);
    expect(find.text('Test car'), findsOneWidget);
  });
}
