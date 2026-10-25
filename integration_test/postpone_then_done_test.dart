// integration_test/postpone_then_done_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_app.dart';
import 'test_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets(
    'postpone then mark done with mileage above current',
    (tester) async {
      await runTestApp();

      await waitFor(tester, find.text('Welcome'));
      await passOnboardingIfNeeded(tester);

      expect(find.text('240,000'), findsOneWidget);

      // nextKm = 240 400 → kmLeft = 400 ≤ yellowKm (500) → status = soon.
      await createRuleIfNeeded(
        tester,
        name: 'Brake pads',
        nextKm: '240400',
        intervalKm: '30000',
      );

      await goToSchedule(tester);

      // Отложить.
      await waitFor(tester, find.text('Brake pads'));
      await waitFor(tester, find.text('[Postpone]'));
      await tester.tap(find.text('[Postpone]'));
      await tester.pumpAndSettle();

      // Диалог отложки.
      await waitFor(tester, find.text('Postpone maintenance'));

      // Выбрать «For 3 days» (radio).
      await tester.tap(find.text('For 3 days'));
      await tester.pumpAndSettle();

      // Нажать кнопку «Postpone» (применить).
      await tester.tap(find.text('Postpone'));
      await tester.pumpAndSettle();

      // Секция «Postponed».
      await waitFor(tester, find.text('Postponed'));
      expect(find.text('Postponed'), findsOneWidget);

      // Найти [Complete] в карточке «Brake pads».
      final card = find.ancestor(
        of: find.text('Brake pads'),
        matching: find.byType(Card),
      );
      expect(card, findsOneWidget);

      final completeButton = find.descendant(
        of: card,
        matching: find.text('[Complete]'),
      );
      expect(completeButton, findsOneWidget);

      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      await waitFor(tester, find.text('Complete work'));
      expect(find.text('Complete work'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Completion mileage'),
        '260000',
      );
      await tester.pump();

      await hideKeyboard(tester);
      await tapButton(tester, find.text('Save'));

      await waitFor(tester, find.text('Update car mileage?'));
      await tester.tap(find.text('Yes'));

      await waitFor(tester, find.textContaining('Brake pads completed'));

      await waitForGone(tester, find.textContaining('Brake pads completed'));
      await waitFor(tester, find.text('260,000'));
      expect(find.text('260,000'), findsOneWidget);

      // Запись в истории.
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      await waitFor(tester, find.text('Brake pads'));
      expect(find.text('Brake pads'), findsOneWidget);
    },
  );
}
