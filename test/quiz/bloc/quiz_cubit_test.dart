import 'dart:math';

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
    status: QuizStatus.initial,
    loadingStatus: FormzSubmissionStatus.success,
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
    loadingStatus: FormzSubmissionStatus.failure,
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
        'given successful load from repo, loads correct order of `loadStatus`',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId)).thenReturn(SeedData.wowQuiz);
          when(() => repository.getQuestions(quizId))
              .thenReturn(SeedData.wowQuestions);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(loadingStatus: FormzSubmissionStatus.inProgress),
          const QuizState(
            loadingStatus: FormzSubmissionStatus.success,
            quiz: SeedData.wowQuiz,
            quizQuestions: SeedData.wowQuestions,
            questionIndex: 1,
          ),
        ],
      );

      blocTest(
        'given `repo.getQuiz()` failure, loads correct order of `loadStatus`',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId))
              .thenThrow(getQuizFailedException);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(loadingStatus: FormzSubmissionStatus.inProgress),
          QuizState(
            loadingStatus: FormzSubmissionStatus.failure,
            error: getQuizFailedException.toString(),
          ),
        ],
      );

      blocTest(
        'given `repo.getQuestions()` failure, loads correct order of `loadStatus`',
        build: () => cubit,
        act: (contextCubit) {
          when(() => repository.getQuiz(quizId)).thenReturn(SeedData.wowQuiz);
          when(() => repository.getQuestions(quizId))
              .thenThrow(getQuestionsFailedException);
          contextCubit.loadQuiz();
        },
        expect: () => <QuizState>[
          const QuizState(loadingStatus: FormzSubmissionStatus.inProgress),
          QuizState(
            loadingStatus: FormzSubmissionStatus.failure,
            error: getQuestionsFailedException.toString(),
          ),
        ],
      );
    });

    group('[startQuiz()]', () {
      blocTest(
        'given `status` is not initial, does nothing',
        build: () => cubit,
        seed: () {
          final possibleValues = QuizStatus.values
              .where((element) => element != QuizStatus.initial)
              .toList();
          final randomValue =
              possibleValues[Random().nextInt(possibleValues.length)];
          return QuizState(status: randomValue);
        },
        act: (contextCubit) => contextCubit.startQuiz(),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given `loadStatus` is not success, does nothing',
        build: () => cubit,
        seed: () {
          final possibleValues = FormzSubmissionStatus.values
              .where((element) => element != FormzSubmissionStatus.success)
              .toList();
          final randomValue =
              possibleValues[Random().nextInt(possibleValues.length)];
          return QuizState(loadingStatus: randomValue);
        },
        act: (contextCubit) => contextCubit.startQuiz(),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given `loadStatus` is success and `status` is initial, emits new state with started `status`',
        build: () => cubit,
        seed: () => successLoadedSeedState,
        act: (contextCubit) => contextCubit.startQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(status: QuizStatus.started),
        ],
      );
    });

    group('[restartQuiz()]', () {
      blocTest(
        'given current `status` initial, does nothing',
        build: () => cubit,
        seed: () => successLoadedSeedState.copyWith(status: QuizStatus.initial),
        act: (contextCubit) => contextCubit.restartQuiz(),
        verify: (contextCubit) {
          verifyNever(() => repository.getQuiz(quizId));
          verifyNever(() => repository.getQuestions(quizId));
        },
        expect: () => <QuizState>[],
      );

      group('given current `status` is not initial', () {
        final possibleStatuses =
            QuizStatus.values.where((element) => element != QuizStatus.initial);

        for (var status in possibleStatuses) {
          blocTest(
            'with `status` being ${status.toString()}, emits new state with initial `status`',
            build: () => cubit,
            seed: () =>
                lastQuestionWithCorrectChoiceSelected.copyWith(status: status),
            act: (contextCubit) {
              when(() => repository.getQuiz(quizId))
                  .thenReturn(SeedData.wowQuiz);
              when(() => repository.getQuestions(quizId))
                  .thenReturn(SeedData.wowQuestions);
              contextCubit.restartQuiz();
            },
            expect: () => <QuizState>[
              const QuizState(status: QuizStatus.initial),
              const QuizState(
                loadingStatus: FormzSubmissionStatus.inProgress,
                status: QuizStatus.initial,
              ),
              const QuizState(
                loadingStatus: FormzSubmissionStatus.success,
                status: QuizStatus.initial,
                quiz: SeedData.wowQuiz,
                quizQuestions: SeedData.wowQuestions,
                questionIndex: 1,
              ),
            ],
          );
        }
      });
    });

    group('[selectAnswer()]', () {
      group('with current `answerStatus` being initial', () {
        final randomChoice =
            OptionIndex.values[Random().nextInt(OptionIndex.values.length)];
        blocTest(
          'given valid choice, emits state with updated `selectedOption` and sets `answerStatus` to selected',
          seed: () => successLoadedSeedState,
          build: () => cubit,
          act: (contextCubit) => contextCubit.selectAnswer(randomChoice),
          expect: () => <QuizState>[
            successLoadedSeedState.copyWith(
              selectedOption: randomChoice,
              answerStatus: AnswerStatus.selected,
            ),
          ],
        );
      });

      blocTest(
        'given question depleted, does nothing',
        seed: () => successLoadedSeedState.copyWith(questionDepleted: true),
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given question confirmed, does nothing',
        seed: () => successLoadedSeedState.copyWith(questionDepleted: true),
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[],
      );

      blocTest(
        'given current answer status is selected, emits new state with updated option',
        seed: () => successLoadedSeedState.copyWith(
          answerStatus: AnswerStatus.selected,
          selectedOption: OptionIndex.B,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.selected,
            selectedOption: OptionIndex.C,
          ),
        ],
      );

      group('given `loadStatus` is not success', () {
        final statuses = FormzSubmissionStatus.values
            .where((element) => element != FormzSubmissionStatus.success)
            .toList();
        for (var status in statuses) {
          blocTest(
            'with `loadStatus` being ${status.toString()}, does nothing',
            build: () => cubit,
            act: (contextCubit) => contextCubit.selectAnswer(OptionIndex.C),
            expect: () => <QuizState>[],
          );
        }
      });
    });

    group('[continueQuestion()]', () {
      blocTest(
        'given quiz is complete, does nothing',
        seed: () =>
            successLoadedSeedState.copyWith(status: QuizStatus.complete),
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
            status: QuizStatus.complete,
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
            status: QuizStatus.complete,
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
            status: QuizStatus.complete,
          ),
        ],
      );
    });

    group('[terminateTime()]', () {
      group('given question is confirmed or depleted', () {
        final List<AnswerStatus> possibleStatuses = [
          AnswerStatus.confirmed,
          AnswerStatus.depleted,
        ];
        for (var status in possibleStatuses) {
          blocTest(
            'with status being ${status.toString()}, does nothing',
            build: () => cubit,
            act: (contextCubit) => contextCubit.terminateTime(),
            expect: () => <QuizState>[],
          );
        }
      });

      blocTest(
        'given current status is initial, depletes question',
        build: () => cubit,
      );

      blocTest(
        'given question not depleted, emits new state with marking question depleted',
        seed: () => successLoadedSeedState,
        build: () => cubit,
        act: (contextCubit) => contextCubit.terminateTime(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionDepleted: true,
          ),
        ],
      );
    });
  });
}
