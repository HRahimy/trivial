import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/quizzes_keys.dart';

import '../../mocks/quizzes_cubit_mock.dart';
import '../fixtures/quiz_list_fixture.dart';

void main() {
  late QuizzesCubit cubit;
  const QuizzesState loadedState = QuizzesState(
    quizzes: SeedData.quizzes,
    status: FormzSubmissionStatus.success,
  );
  
  group('[QuizList]', () {
    setUp(() {
      cubit = QuizzesCubitMock();
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
  });
}
