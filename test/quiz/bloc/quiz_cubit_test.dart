import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../mocks/quiz_repository_mock.dart';

void main() {
  late QuizRepository repository;
  const int quizId = 32;
  late QuizCubit cubit;

  setUpAll(() {
    registerFallbackValue(FakeQuizState());
  });

  setUp(() {
    repository = MockQuizRepository();
    cubit = QuizCubit(
      quizId: quizId,
      quizRepository: repository,
    );
  });

  group(['QuizCubit'], () {
    test('initial state is `QuizState()`', () {
      expect(cubit.state, const QuizState());
    });
  });
}
