// integration_test/create_rule_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart';
import 'test_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('create rule → mark done → history', (tester) async {
    await runTestApp();

    await waitFor(tester, find.text('Welcome'));
    await passOnboardingIfNeeded(tester);

    await createRuleIfNeeded(
      tester,
      name: 'Oil change',
      nextKm: '250000',
      intervalKm: '10000',
    );

    await goToSchedule(tester);

    await waitFor(tester, find.text('Oil change'));
    expect(find.text('Oil change'), findsOneWidget);

    await tester.tap(find.text('[Complete]'));
    await tester.pumpAndSettle();

    await waitFor(tester, find.text('Complete work'));
    expect(find.text('Complete work'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Completion mileage'),
      '250000',
    );
    await tester.pump();

    await hideKeyboard(tester);
    await tapButton(tester, find.text('Save'));

    await waitFor(tester, find.text('Update car mileage?'));
    expect(find.text('Update car mileage?'), findsOneWidget);

    await tester.tap(find.text('Yes'));

    await waitFor(tester, find.textContaining('Oil change completed'));
    expect(
      find.textContaining('Oil change completed'),
      findsOneWidget,
    );

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    await waitFor(tester, find.text('Oil change'));
    expect(find.text('Oil change'), findsOneWidget);
  });
}
