import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/quizzes_keys.dart';
import 'package:trivial/quizzes/widgets/quiz_list_screen.dart';

import '../../mocks/quiz_repository_mock.dart';

void main() {
  group('[QuizList]', () {
    testWidgets('is rendered', (tester) async {
      final repository = MockQuizRepository();
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
  });
}
