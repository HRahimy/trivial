import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';

import '../fixtures/abort_confirm_dialog_fixture.dart';

void main() {
  group('[AbortConfirmDialog]', () {
    testWidgets('renders expected components', (tester) async {
      await tester.pumpWidget(const AbortConfirmDialogFixture());

      final widgetFinder = find.byType(AbortConfirmDialog);
      final dialogFinder = find.descendant(
        of: widgetFinder,
        matching: find.byType(AlertDialog),
      );
      final titleFinder = find.descendant(
        of: dialogFinder,
        matching: find.byKey(QuizKeys.abortDialogTitle),
      );
      final subtitleFinder = find.descendant(
        of: dialogFinder,
        matching: find.byKey(QuizKeys.abortDialogSubtitle),
      );
      final cancelButtonFinder = find.descendant(
        of: dialogFinder,
        matching: find.byKey(QuizKeys.abortDialogCancelButton),
      );
      final cancelButtonTextFinder = find.descendant(
        of: cancelButtonFinder,
        matching: find.byKey(QuizKeys.abortDialogCancelButtonText),
      );
      final acceptButtonFinder = find.descendant(
        of: dialogFinder,
        matching: find.byKey(QuizKeys.abortDialogAcceptButton),
      );
      final acceptButtonTextFinder = find.descendant(
        of: acceptButtonFinder,
        matching: find.byKey(QuizKeys.abortDialogAcceptButtonText),
      );

      expect(widgetFinder, findsOneWidget);
      expect(dialogFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);
      expect(cancelButtonFinder, findsOneWidget);
      expect(cancelButtonTextFinder, findsOneWidget);
      expect(acceptButtonFinder, findsOneWidget);
      expect(acceptButtonTextFinder, findsOneWidget);

      final dialogWidget = tester.widget(dialogFinder);
      final titleWidget = tester.widget(titleFinder);
      final subtitleWidget = tester.widget(subtitleFinder);
      final cancelButtonWidget = tester.widget(cancelButtonFinder);
      final cancelButtonTextWidget = tester.widget(cancelButtonTextFinder);
      final acceptButtonWidget = tester.widget(acceptButtonFinder);
      final acceptButtonTextWidget = tester.widget(acceptButtonTextFinder);

      expect(dialogWidget.runtimeType, equals(AlertDialog));
      expect(titleWidget.runtimeType, equals(Text));
      expect(subtitleWidget.runtimeType, equals(Text));
      expect(cancelButtonWidget.runtimeType, equals(TextButton));
      expect(cancelButtonTextWidget.runtimeType, equals(Text));
      expect(acceptButtonWidget.runtimeType, equals(TextButton));
      expect(acceptButtonTextWidget.runtimeType, equals(TextButton));
    });
  });
}
