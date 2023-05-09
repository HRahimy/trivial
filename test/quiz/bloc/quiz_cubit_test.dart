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

    group('[confirmAnswer()]', () {
      final nonSelectedStatuses = AnswerStatus.values
          .where((element) => element != AnswerStatus.selected)
          .toList();
      for (var status in nonSelectedStatuses) {
        blocTest(
          'given current `answerStatus` is ${status.toString()}, does nothing',
          seed: () => successLoadedSeedState.copyWith(answerStatus: status),
          build: () => cubit,
          act: (contextCubit) => contextCubit.confirmAnswer(),
          expect: () => <QuizState>[],
        );
      }

      group('with current `answerStatus` being selected', () {
        blocTest(
          'given selected choice was the correct option, emits new state with new score and confirmed `answerStatus`',
          seed: () => successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.selected,
            selectedOption:
                successLoadedSeedState.currentQuestion.correctOption,
          ),
          build: () => cubit,
          act: (contextCubit) => contextCubit.confirmAnswer(),
          expect: () => <QuizState>[
            successLoadedSeedState.copyWith(
              answerStatus: AnswerStatus.confirmed,
              selectedOption:
                  successLoadedSeedState.currentQuestion.correctOption,
              score: successLoadedSeedState.score +
                  successLoadedSeedState.currentQuestion.points,
            ),
          ],
        );

        final incorrectChoices = OptionIndex.values
            .where((element) =>
                element != successLoadedSeedState.currentQuestion.correctOption)
            .toList();
        final incorrectChoice =
            incorrectChoices[Random().nextInt(incorrectChoices.length)];
        blocTest(
          'given selected choice was not the correct option, emits new state with same score and confirmed `answerStatus`',
          seed: () => successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.selected,
            selectedOption: incorrectChoice,
          ),
          build: () => cubit,
          act: (contextCubit) => contextCubit.confirmAnswer(),
          expect: () => <QuizState>[
            successLoadedSeedState.copyWith(
              answerStatus: AnswerStatus.confirmed,
              selectedOption: incorrectChoice,
            )
          ],
        );
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

      // given current status is not confirmed or depleted, does nothing
      final nonCompleteStatus = AnswerStatus.values
          .where((element) =>
              element != AnswerStatus.confirmed &&
              element != AnswerStatus.depleted)
          .toList();
      for (var status in nonCompleteStatus) {
        blocTest(
          'given current status is ${status.toString()}, does nothing',
          seed: () => successLoadedSeedState.copyWith(answerStatus: status),
          build: () => cubit,
          act: (contextCubit) => contextCubit.continueQuiz(),
          expect: () => <QuizState>[],
        );
      }

      // given current status is confirmed or depleted, increments to next question
      final completeStatus = [
        AnswerStatus.confirmed,
        AnswerStatus.depleted,
      ];
      for (var status in completeStatus) {
        blocTest(
          'given current status is ${status.toString()}, increments to next question',
          seed: () => successLoadedSeedState.copyWith(
            answerStatus: status,
          ),
          build: () => cubit,
          act: (contextCubit) => contextCubit.continueQuiz(),
          expect: () => <QuizState>[
            successLoadedSeedState.copyWith(
              questionIndex: successLoadedSeedState.questionIndex + 1,
              answerStatus: AnswerStatus.initial,
            )
          ],
        );
      }

      blocTest(
        'given last question, ends quiz',
        seed: () => successLoadedSeedState.copyWith(
          questionIndex: lastQuestionIndex,
          answerStatus: AnswerStatus.confirmed,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.continueQuiz(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            questionIndex: lastQuestionIndex,
            answerStatus: AnswerStatus.confirmed,
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
            seed: () => successLoadedSeedState.copyWith(
              answerStatus: status,
            ),
            build: () => cubit,
            act: (contextCubit) => contextCubit.terminateTime(),
            expect: () => <QuizState>[],
          );
        }
      });

      blocTest(
        'given current status is initial, depletes question',
        seed: () => successLoadedSeedState.copyWith(
          answerStatus: AnswerStatus.initial,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.terminateTime(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.depleted,
          ),
        ],
      );

      final correctChoice =
          successLoadedSeedState.currentQuestion.correctOption;
      final incorrectChoices = OptionIndex.values
          .where((element) => element != correctChoice)
          .toList();
      final incorrectChoice =
          incorrectChoices[Random().nextInt(incorrectChoices.length)];
      blocTest(
        'given `answerStatus` is selected and correct choice selected, emits new state with `answerStatus` confirmed and updated points',
        seed: () => successLoadedSeedState.copyWith(
          answerStatus: AnswerStatus.selected,
          selectedOption: correctChoice,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.terminateTime(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.confirmed,
            score: successLoadedSeedState.score +
                successLoadedSeedState.currentQuestion.points,
            selectedOption: correctChoice,
          ),
        ],
      );

      blocTest(
        'given `answerStatus` is selected and incorrect choice selected, emits new state with confirmed `answerStatus` and same points',
        seed: () => successLoadedSeedState.copyWith(
          answerStatus: AnswerStatus.selected,
          selectedOption: incorrectChoice,
        ),
        build: () => cubit,
        act: (contextCubit) => contextCubit.terminateTime(),
        expect: () => <QuizState>[
          successLoadedSeedState.copyWith(
            answerStatus: AnswerStatus.confirmed,
            selectedOption: incorrectChoice,
          ),
        ],
      );
    });
  });
}
