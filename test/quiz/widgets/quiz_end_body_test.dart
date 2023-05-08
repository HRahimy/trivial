import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/quiz_end_body.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../tests_navigator_observer.dart';
import '../fixtures/loaded_quiz_screen_fixture.dart';

void main() {
  late TestsNavigatorObserver navObserver;
  late QuizCubit cubit;
  const QuizState loadedState = QuizState(
    quiz: SeedData.wowQuiz,
    quizQuestions: SeedData.wowQuestions,
    questionIndex: 1,
    status: QuizStatus.complete,
    score: 32,
    loadingStatus: FormzSubmissionStatus.success,
  );
  setUp(() {
    cubit = QuizCubitMock();
    navObserver = TestsNavigatorObserver();
  });
  group('[EndBody]', () {
    testWidgets('given `state.status` is not complete, EndBody does not exist',
        (tester) async {
      final possibleStatuses = QuizStatus.values
          .where((element) => element != QuizStatus.complete)
          .toList();

      for (var status in possibleStatuses) {
        when(() => cubit.state).thenReturn(loadedState.copyWith(
          status: status,
        ));

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        expect(find.byKey(QuizKeys.quizEndBody), findsNothing);
      }
    });

    testWidgets('given quiz is complete, body components are rendered',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith());

      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
      ));

      // body exists
      final bodyFinder = find.byKey(QuizKeys.quizEndBody);
      expect(bodyFinder, findsOneWidget);

      final bodyWidget = tester.widget(bodyFinder);
      expect(bodyWidget.runtimeType, equals(QuizEndBody));

      //region flavor text exists
      final sectionFinder = find.byKey(QuizKeys.quizEndFlavorTextSection);
      final textFinder = find.descendant(
        of: find.byKey(QuizKeys.quizEndFlavorTextSection),
        matching: find.byKey(QuizKeys.quizEndFlavorText),
      );

      expect(sectionFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(find.byKey(QuizKeys.quizEndScoreText), findsOneWidget);
      //endregion

      //region controls section
      final controlsSectionFinder = find.byKey(QuizKeys.quizEndControlsSection);
      expect(controlsSectionFinder, findsOneWidget);
      //endregion

      //region try again button
      final tryButtonFinder = find.descendant(
        of: controlsSectionFinder,
        matching: find.byKey(QuizKeys.tryAgainButton),
      );
      final tryButtonTextFinder = find.descendant(
        of: tryButtonFinder,
        matching: find.byKey(QuizKeys.tryAgainButtonText),
      );
      expect(tryButtonFinder, findsOneWidget);
      expect(tryButtonTextFinder, findsOneWidget);

      final tryButtonTextWidget = tester.widget(tryButtonTextFinder);
      expect(tryButtonTextWidget.runtimeType, equals(Text));
      expect((tryButtonTextWidget as Text).data, equals('Try Again!'));
      //endregion

      //region goodbye button
      final byeButtonFinder = find.descendant(
        of: controlsSectionFinder,
        matching: find.byKey(QuizKeys.goodbyeButton),
      );
      final byeButtonTextFinder = find.descendant(
        of: byeButtonFinder,
        matching: find.byKey(QuizKeys.goodbyeButtonText),
      );
      expect(byeButtonFinder, findsOneWidget);
      expect(byeButtonTextFinder, findsOneWidget);

      final byeButtonTextWidget = tester.widget(byeButtonTextFinder);
      expect(byeButtonTextWidget.runtimeType, equals(Text));
      expect((byeButtonTextWidget as Text).data, equals('Goodbye!'));
      //endregion
    });

    testWidgets('quiz end score text is correct', (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith());

      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
      ));

      final text = tester.widget(find.byKey(QuizKeys.quizEndScoreText));

      expect(text.runtimeType, Text);
      expect((text as Text).data, equals('You reached level 32'));
    });

    testWidgets('pressing "Try Again!" button triggers restart event in state',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith());

      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
      ));

      await tester.tap(find.byKey(QuizKeys.tryAgainButton));
      verify(() => cubit.restartQuiz()).called(1);
    });

    testWidgets('pressing "Goodbye!" button triggers `pop` event in navigator',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith());

      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
        navigatorObserver: navObserver,
      ));

      await tester.tap(find.byKey(QuizKeys.goodbyeButton));
      await tester.pumpAndSettle();

      expect(navObserver.poppedCount, equals(1));
    });
  });
}