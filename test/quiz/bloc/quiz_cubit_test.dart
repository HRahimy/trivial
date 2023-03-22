import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../mocks/quiz_repository_mock.dart';

void main() {
  late QuizRepository repository;
  const int quizId = 32;
  late QuizCubit cubit;

  final Exception getQuizFailedException = Exception('failed to get quiz');
  final Exception getQuestionsFailedException =
      Exception('failed to get questions');

  const QuizState successLoadedSeedState = QuizState(
    quiz: SeedData.wowQuiz,
    quizQuestions: SeedData.wowQuestions,
    status: FormzSubmissionStatus.success,
    questionIndex: 1,
    error: '',
  );

  QuizState failLoadedSeedState = QuizState(
    status: FormzSubmissionStatus.failure,
    error: getQuizFailedException.toString(),
  );

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

    group('[loadQuiz()]', () {
      blocTest(
        'calls `getQuiz()` and `getQuestions()` functions from repository',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId)).thenReturn(SeedData.wowQuiz);
          when(() => repository.getQuestions(quizId))
              .thenReturn(SeedData.wowQuestions);
          contextCubit.loadQuiz();
        },
        verify: (contextCubit) {
          verify(() => repository.getQuiz(quizId)).called(1);
          verify(() => repository.getQuestions(quizId)).called(1);
        },
      );

      blocTest(
        'given successful load from repo, loads correct order of statuses',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId)).thenReturn(SeedData.wowQuiz);
          when(() => repository.getQuestions(quizId))
              .thenReturn(SeedData.wowQuestions);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(status: FormzSubmissionStatus.inProgress),
          const QuizState(
            status: FormzSubmissionStatus.success,
            quiz: SeedData.wowQuiz,
            quizQuestions: SeedData.wowQuestions,
            questionIndex: 1,
          ),
        ],
      );

      blocTest(
        'given `repo.getQuiz()` failure, loads correct order of statuses',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId))
              .thenThrow(getQuizFailedException);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(status: FormzSubmissionStatus.inProgress),
          QuizState(
            status: FormzSubmissionStatus.failure,
            error: getQuizFailedException.toString(),
          ),
        ],
      );

      blocTest(
        'given `repo.getQuestions()` failure, loads correct order of statuses',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId)).thenReturn(SeedData.wowQuiz);
          when(() => repository.getQuestions(quizId))
              .thenThrow(getQuestionsFailedException);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(status: FormzSubmissionStatus.inProgress),
          QuizState(
            status: FormzSubmissionStatus.failure,
            error: getQuestionsFailedException.toString(),
          ),
        ],
      );
    });

    group('[selectAnswer()]', () {
      blocTest(
        'given valid choice, emits new state with choice and `choiceSelected=true`',
        seed: () => successLoadedSeedState,
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            selectedOption: OptionIndex.C,
            choiceSelected: true,
          ),
        ],
      );

      blocTest(
        'given question depleted, does not emit new state',
        seed: () => successLoadedSeedState.copyWith(questionDepleted: true),
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given quiz not loaded, does not emit new state',
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given quiz load failure, does not emit new state',
        seed: () => failLoadedSeedState,
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[],
      );
    });

    group('[continueQuestion()]', () {
      blocTest(
        'given quiz is complete, does nothing',
        seed: () => successLoadedSeedState.copyWith(complete: true),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given correct choice selected, emits state with updated question and score',
        seed: () => successLoadedSeedState.copyWith(
          selectedOption: successLoadedSeedState.currentQuestion.correctOption,
          choiceSelected: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: successLoadedSeedState.questionIndex + 1,
            score: successLoadedSeedState.score +
                successLoadedSeedState.currentQuestion.points,
          ),
        ],
      );
    });
  });
}
