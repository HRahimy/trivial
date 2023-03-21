import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
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

    group('[loadInitial()]', () {
      blocTest(
        'calls `getQuizzes()` from repository',
        build: () => cubit,
        act: (cubit) => cubit.loadInitial(),
        verify: (contextCubit) {
          verify(() => repository.getQuizzes()).called(1);
        },
      );
      blocTest(
        'given successful load from repository, emits correct order of statuses',
        build: () => cubit,
        act: (cubit) {
          when(() => repository.getQuizzes()).thenReturn(SeedData.quizzes);
          cubit.loadInitial();
        },
        expect: () => <QuizzesState>[
          const QuizzesState(status: FormzSubmissionStatus.inProgress),
          const QuizzesState(
            status: FormzSubmissionStatus.success,
            quizzes: SeedData.quizzes,
          ),
        ],
      );

      blocTest(
        'given load failure from repository, emits correct order of statuses',
        build: () => cubit,
        act: (cubit) {
          when(() => repository.getQuizzes())
              .thenThrow(Exception('test error'));
          cubit.loadInitial();
        },
        expect: () => <QuizzesState>[
          const QuizzesState(status: FormzSubmissionStatus.inProgress),
          QuizzesState(
            status: FormzSubmissionStatus.failure,
            error: Exception('test error').toString(),
          ),
        ],
      );
    });
  });
}
