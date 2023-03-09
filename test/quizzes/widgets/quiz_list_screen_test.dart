import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/widgets/quiz_screen.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/quizzes_keys.dart';

import '../../mocks/quizzes_cubit_mock.dart';
import '../../tests_navigator_observer.dart';
import '../fixtures/quiz_list_fixture.dart';

void main() {
  late QuizzesCubit cubit;
  late TestsNavigatorObserver navObserver;
  const QuizzesState loadedState = QuizzesState(
    quizzes: SeedData.quizzes,
    status: FormzSubmissionStatus.success,
  );

  group('[QuizList]', () {
    setUp(() {
      cubit = QuizzesCubitMock();
      navObserver = TestsNavigatorObserver();
    });

    testWidgets('is rendered', (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      await tester.pumpWidget(
        QuizListFixture(cubit: cubit),
      );

      expect(find.byKey(QuizzesKeys.quizList), findsOneWidget);
    });

    testWidgets('button is rendered for a quiz', (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      final Quiz firstQuiz = SeedData.quizzes[0];

      await tester.pumpWidget(
        QuizListFixture(cubit: cubit),
      );

      expect(
        find.byKey(QuizzesKeys.quizItemButton('${firstQuiz.id}')),
        findsOneWidget,
      );
    });

    testWidgets('quiz button contains correct text', (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      final Quiz firstQuiz = SeedData.quizzes[0];

      await tester.pumpWidget(
        QuizListFixture(cubit: cubit),
      );

      final finder = find.descendant(
        of: find.byKey(QuizzesKeys.quizItemButton('${firstQuiz.id}')),
        matching: find.byKey(QuizzesKeys.quizItemButtonText('${firstQuiz.id}')),
      );
      final widget = tester.widget(finder) as Text;

      expect(finder, findsOneWidget);
      expect(widget.data, firstQuiz.name);
    });

    // Solution for testing navigation adapted from:
    // https://harsha973.medium.com/widget-testing-pushing-a-new-page-13cd6a0bb055
    testWidgets('quiz button triggers navigation', (tester) async {
      bool isQuizScreenPushed = false;
      when(() => cubit.state).thenReturn(loadedState);

      await tester.pumpWidget(QuizListFixture(
        cubit: cubit,
        navigatorObserver: navObserver,
      ));

      navObserver.attachPushRouteObserver(
        QuizScreen.routeName,
        () {
          isQuizScreenPushed = true;
        },
      );

      await tester.tap(
        find.byKey(QuizzesKeys.quizItemButton('${SeedData.quizzes[0].id}')),
      );
      await tester.pumpAndSettle();

      expect(isQuizScreenPushed, true);
    });
  });
}
