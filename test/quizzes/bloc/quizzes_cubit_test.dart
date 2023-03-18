import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';

import '../../mocks/quiz_repository_mock.dart';
import '../../mocks/quizzes_cubit_mock.dart';

void main() {
  late QuizRepository repository;
  late QuizzesCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeQuizzesState());
  });
  setUp(() {
    repository = MockQuizRepository();
    cubit = QuizzesCubit(quizRepository: repository);
  });

  group('[QuizzesCubit]', () {
    test('initial state is `QuizzesState()`', () {
      expect(cubit.state, equals(const QuizzesState()));
    });
  });
}
