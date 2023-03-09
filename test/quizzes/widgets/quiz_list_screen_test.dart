import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/quizzes_keys.dart';
import 'package:trivial/quizzes/widgets/quiz_list_screen.dart';

import '../../mocks/quiz_repository_mock.dart';

void main() {
  late QuizRepository repository;
  group('[QuizList]', () {
    setUp(() {
      repository = MockQuizRepository();
    });

    testWidgets('is rendered', (tester) async {
      when(() => repository.getQuizzes()).thenReturn(SeedData.quizzes);

      await tester.pumpWidget(
        RepositoryProvider<QuizRepository>.value(
          value: repository,
          child: const MaterialApp(
            home: QuizListScreen(),
          ),
        ),
      );

      expect(find.byKey(QuizzesKeys.quizList), findsOneWidget);
    });

    testWidgets('button is rendered for a quiz', (tester) async {
      when(() => repository.getQuizzes()).thenReturn(SeedData.quizzes);

      final Quiz firstQuiz = SeedData.quizzes[0];

      await tester.pumpWidget(
        RepositoryProvider<QuizRepository>.value(
          value: repository,
          child: const MaterialApp(
            home: QuizListScreen(),
          ),
        ),
      );

      expect(
        find.byKey(QuizzesKeys.quizItemButton('${firstQuiz.id}')),
        findsOneWidget,
      );
    });

    testWidgets('quiz button contains correct text', (tester) async {
      when(() => repository.getQuizzes()).thenReturn(SeedData.quizzes);

      final Quiz firstQuiz = SeedData.quizzes[0];

      await tester.pumpWidget(
        RepositoryProvider<QuizRepository>.value(
          value: repository,
          child: const MaterialApp(
            home: QuizListScreen(),
          ),
        ),
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
