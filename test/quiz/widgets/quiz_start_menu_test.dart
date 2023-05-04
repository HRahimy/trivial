import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/quiz_start_menu.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../tests_navigator_observer.dart';
import '../fixtures/quiz_body_fixture.dart';

void main() {
  late TestsNavigatorObserver navObserver;
  late QuizCubit cubit;
  const QuizState loadedState = QuizState(
    quiz: SeedData.wowQuiz,
    quizQuestions: SeedData.wowQuestions,
    questionIndex: 1,
    status: QuizStatus.initial,
    loadingStatus: FormzSubmissionStatus.success,
  );

  setUp(() {
    cubit = QuizCubitMock();
    navObserver = TestsNavigatorObserver();
  });

  group('[QuizStartMenu]', () {
    testWidgets('given `status` is not initial, does not show start menu',
        (tester) async {
      final possibleStatuses = QuizStatus.values
          .where((element) => element != QuizStatus.initial)
          .toList();

      for (var status in possibleStatuses) {
        when(() => cubit.state)
            .thenReturn(loadedState.copyWith(status: status));
        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        expect(find.byKey(QuizKeys.quizStartMenu), findsNothing);
      }
    });

    testWidgets('given `status` is initial, renders start menu correctly',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState);
      await tester.pumpWidget(QuizBodyFixture(
        quizCubit: cubit,
      ));

      //region Body
      final bodyFinder = find.byKey(QuizKeys.quizStartMenu);
      expect(bodyFinder, findsOneWidget);

      final bodyWidget = tester.widget(bodyFinder);
      expect(bodyWidget.runtimeType, equals(QuizStartMenu));
      //endregion

      //region Title
      final titleFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuTitle),
      );
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget(titleFinder);
      expect(titleWidget.runtimeType, equals(Text));
      expect((titleWidget as Text).data, equals(loadedState.quiz.name));
      //endregion

      //region Description
      final descriptionFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuDescriptionText),
      );
      expect(descriptionFinder, findsOneWidget);

      final descriptionWidget = tester.widget(descriptionFinder);
      expect(descriptionWidget.runtimeType, equals(Text));
      expect(
        (descriptionWidget as Text).data,
        equals(loadedState.quiz.description),
      );
      //endregion

      //region Total questions text
      final questionsFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuQuestionsText),
      );
      expect(questionsFinder, findsOneWidget);

      final questionsWidget = tester.widget(questionsFinder);
      expect(questionsWidget.runtimeType, equals(Text));
      expect(
        (questionsWidget as Text).data,
        equals('${loadedState.quizQuestions.length} questions'),
      );
      //endregion

      //region Max possible score text
      final scoreFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuScoreText),
      );
      expect(scoreFinder, findsOneWidget);

      final scoreWidget = tester.widget(scoreFinder);
      expect(scoreWidget.runtimeType, equals(Text));
      final topScore = loadedState.quizQuestions
          .map((e) => e.points)
          .fold(0, (previous, current) => previous + current);
      expect(
        (scoreWidget as Text).data,
        equals('Get a top score of $topScore'),
      );
      //endregion

      //region Play button
      final playFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuPlayButton),
      );
      expect(playFinder, findsOneWidget);

      final playWidget = tester.widget(playFinder);
      expect(playWidget.runtimeType, ElevatedButton);

      final playTextFinder = find.descendant(
        of: playFinder,
        matching: find.byKey(QuizKeys.startMenuPlayButtonText),
      );
      expect(playTextFinder, findsOneWidget);

      final playTextWidget = tester.widget(playTextFinder);
      expect(playTextWidget.runtimeType, equals(Text));
      expect((playTextWidget as Text).data, equals('Play'));
      //endregion

      //region Back button
      final backFinder = find.descendant(
        of: bodyFinder,
        matching: find.byKey(QuizKeys.startMenuBackButton),
      );
      expect(backFinder, findsOneWidget);

      final backWidget = tester.widget(backFinder);
      expect(backWidget.runtimeType, equals(TextButton));

      final backTextFinder = find.descendant(
        of: backFinder,
        matching: find.byKey(QuizKeys.startMenuBackButtonText),
      );
      expect(backTextFinder, findsOneWidget);

      final backTextWidget = tester.widget(backTextFinder);
      expect(backTextWidget.runtimeType, equals(Text));
      expect((backTextWidget as Text).data, equals('Back'));
      //endregion
    });

    testWidgets('pressing back button triggers pop event in navigation',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState);
      await tester.pumpWidget(QuizBodyFixture(
        quizCubit: cubit,
        navigatorObserver: navObserver,
      ));

      await tester.tap(find.byKey(QuizKeys.startMenuBackButton));
      await tester.pumpAndSettle();

      expect(navObserver.poppedCount, equals(1));
    });

    testWidgets('pressing play button triggers `startQuiz()` function in cubit',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState);
      await tester.pumpWidget(QuizBodyFixture(
        quizCubit: cubit,
      ));

      await tester.tap(find.byKey(QuizKeys.startMenuPlayButton));
      await tester.pumpAndSettle();

      verify(() => cubit.startQuiz()).called(1);
    });
  });
}
