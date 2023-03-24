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

  // Solution to get last question index adapted from:
  // https://stackoverflow.com/a/58386492/5472560
  int lastQuestionIndex = successLoadedSeedState.quizQuestions.fold(
    0,
    (max, e) => e.sequenceIndex > max ? e.sequenceIndex : max,
  );

  final QuizState lastQuestionWithCorrectChoiceSelected =
      successLoadedSeedState.copyWith(
    questionIndex: lastQuestionIndex,
    selectedOption: successLoadedSeedState.quizQuestions
        .firstWhere((element) => element.sequenceIndex == lastQuestionIndex)
        .correctOption,
    choiceSelected: true,
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
        'given choice not selected and question not depleted, does nothing',
        seed: () => successLoadedSeedState,
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
            selectedOption:
                successLoadedSeedState.currentQuestion.correctOption,
          ),
        ],
      );

      blocTest(
        'given incorrect choice selected, emits state with new question and same score',
        seed: () => successLoadedSeedState.copyWith(
          selectedOption: OptionIndex.C,
          choiceSelected: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: successLoadedSeedState.questionIndex + 1,
            selectedOption: OptionIndex.C,
          ),
        ],
      );

      blocTest(
        'given correct choice and quiz depleted, emits state with new question and updated score',
        seed: () => successLoadedSeedState.copyWith(
          selectedOption: successLoadedSeedState.currentQuestion.correctOption,
          choiceSelected: true,
          questionDepleted: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: successLoadedSeedState.questionIndex + 1,
            score: successLoadedSeedState.score +
                successLoadedSeedState.currentQuestion.points,
            selectedOption:
                successLoadedSeedState.currentQuestion.correctOption,
          ),
        ],
      );

      blocTest(
        'given no choice selected and quiz depleted, emits new question with same score',
        seed: () => successLoadedSeedState.copyWith(questionDepleted: true),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: successLoadedSeedState.questionIndex + 1,
          ),
        ],
      );

      blocTest(
        'given incorrect choice and quiz depleted, emits new question with same score',
        seed: () => successLoadedSeedState.copyWith(
          selectedOption: OptionIndex.C,
          choiceSelected: true,
          questionDepleted: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: successLoadedSeedState.questionIndex + 1,
            selectedOption: OptionIndex.C,
          ),
        ],
      );

      blocTest(
        'given last question, ends quiz',
        seed: () => successLoadedSeedState.copyWith(
          questionIndex: lastQuestionIndex,
          questionDepleted: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: lastQuestionIndex,
            complete: true,
          ),
        ],
      );

      blocTest(
        'given last question and correct choice selected, ends quiz with updated score',
        seed: () => lastQuestionWithCorrectChoiceSelected,
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          lastQuestionWithCorrectChoiceSelected.copyWith(
            score: lastQuestionWithCorrectChoiceSelected.score +
                lastQuestionWithCorrectChoiceSelected.currentQuestion.points,
            complete: true,
            choiceSelected: false,
          ),
        ],
      );

      blocTest(
        'given last question and incorrect choice selected, ends quiz with same score',
        seed: () => successLoadedSeedState.copyWith(
          questionIndex: lastQuestionIndex,
          selectedOption: OptionIndex.C,
          choiceSelected: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: lastQuestionIndex,
            selectedOption: OptionIndex.C,
            complete: true,
          ),
        ],
      );
    });

    group('[depleteQuestion()]', () {
      blocTest(
        'given question not depleted, emits new state with marking question depleted',
        seed: () => successLoadedSeedState,
        build: () => cubit,
        act: (contextCubit) => contextCubit.depleteQuestion(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionDepleted: true,
          ),
        ],
      );

      blocTest(
        'given question depleted, does nothing',
        seed: () => successLoadedSeedState.copyWith(
          questionDepleted: true,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.depleteQuestion(),
        expect: () => <QuizState>[],
      );
    });
  });
}
