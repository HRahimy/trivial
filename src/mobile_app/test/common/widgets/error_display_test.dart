import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/common/common_keys.dart';

import '../fixtures/error_display_fixture.dart';

void main() {
  group('[ErrorDisplay]', () {
    testWidgets('widget components exist', (tester) async {
      Error testError = ArgumentError('TestError');
      await tester.pumpWidget(ErrorDisplayFixture(
        content: testError.toString(),
      ));

      final displayFinder = find.byKey(CommonKeys.errorDisplay);
      final displayWidget = tester.widget(displayFinder);
      expect(displayFinder, findsOneWidget);
      expect(displayWidget.runtimeType, equals(Scaffold));

      final appBarFinder = find.descendant(
        of: displayFinder,
        matching: find.byType(AppBar),
      );
      expect(appBarFinder, findsOneWidget);

      //region Icon
      final iconFinder = find.descendant(
        of: appBarFinder,
        matching: find.byKey(CommonKeys.errorIcon),
      );
      final iconWidget = tester.widget(iconFinder);
      expect(iconFinder, findsOneWidget);
      expect(iconWidget.runtimeType, Icon);
      expect((iconWidget as Icon).icon, equals(Icons.error_rounded));
      //endregion

      //region Appbar title
      final titleFinder = find.descendant(
        of: appBarFinder,
        matching: find.byKey(CommonKeys.errorAppBarTitle),
      );
      final titleWidget = tester.widget(titleFinder);
      expect(titleFinder, findsOneWidget);
      expect(titleWidget.runtimeType, equals(Text));
      expect((titleWidget as Text).data, equals('Error detected'));
      //endregion

      //region Copy button
      final copyFinder = find.descendant(
        of: displayFinder,
        matching: find.byKey(CommonKeys.errorCopyButton),
      );
      final copyWidget = tester.widget(copyFinder);
      expect(copyFinder, findsOneWidget);
      expect(copyWidget.runtimeType, equals(TextButton));
      //endregion

      //region Copy button text
      final copyTextFinder = find.descendant(
        of: copyFinder,
        matching: find.byKey(CommonKeys.errorCopyButtonText),
      );
      final copyTextWidget = tester.widget(copyTextFinder);
      expect(copyTextFinder, findsOneWidget);
      expect(copyTextWidget.runtimeType, equals(Text));
      expect((copyTextWidget as Text).data, equals('Copy Error'));
      //endregion

      //region Content
      final contentFinder = find.descendant(
        of: displayFinder,
        matching: find.byKey(CommonKeys.errorContent),
      );
      final contentWidget = tester.widget(contentFinder);
      expect(contentFinder, findsOneWidget);
      expect(contentWidget.runtimeType, equals(Text));
      expect((contentWidget as Text).data, equals(testError.toString()));
      //endregion
    });

    testWidgets('tapping copy opens snackbar', (tester) async {
      Error testError = ArgumentError('TestError');
      await tester.pumpWidget(ErrorDisplayFixture(
        content: testError.toString(),
      ));

      await tester.tap(find.byKey(CommonKeys.errorCopyButton));
      await tester.pump();

      final snackFinder = find.byKey(CommonKeys.errorCopySnackbar);
      final snackWidget = tester.widget(snackFinder);
      final snackTextFinder = find.descendant(
        of: snackFinder,
        matching: find.byKey(CommonKeys.errorCopySnackbarText),
      );
      final snackTextWidget = tester.widget(snackTextFinder);
      expect(snackFinder, findsOneWidget);
      expect(snackWidget.runtimeType, equals(SnackBar));
      expect(snackTextFinder, findsOneWidget);
      expect(snackTextWidget.runtimeType, equals(Text));
      expect((snackTextWidget as Text).data, equals('Copied to clipboard'));
    });
  });
}
