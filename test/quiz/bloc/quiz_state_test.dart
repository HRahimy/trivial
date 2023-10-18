import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

void main() {
  const Quiz mockQuiz = Quiz(id: 3232, name: 'test quiz');
  const Map<int, OptionIndex> mockAnswers = {
    1: OptionIndex.A,
    2: OptionIndex.A,
    3: OptionIndex.B,
    4: OptionIndex.A,
    5: OptionIndex.C,
  };

  group('[QuizState]', () {
    test('supports value comparisons', () {
      expect(const QuizState(), const QuizState());
    });

    group('[selectedOption] property', () {
      test(
          'given `answerStatus` is initial and random choice passed to constructor property, returns null',
          () {
        final randomChoice =
            OptionIndex.values[Random().nextInt(OptionIndex.values.length)];
        final state = QuizState(
          answerStatus: AnswerStatus.initial,
          selectedOption: randomChoice,
        );
        expect(state.selectedOption, isNull);
      });
      test('given `answerStatus` is selected, returns current choice', () {
        final randomChoice =
            OptionIndex.values[Random().nextInt(OptionIndex.values.length)];
        final state = QuizState(
          selectedOption: randomChoice,
          answerStatus: AnswerStatus.selected,
        );
        expect(state.selectedOption, equals(randomChoice));
      });
      test('given `answerStatus` is confirmed, returns current choice', () {
        final randomChoice =
            OptionIndex.values[Random().nextInt(OptionIndex.values.length)];
        final state = QuizState(
          selectedOption: randomChoice,
          answerStatus: AnswerStatus.confirmed,
        );
        expect(state.selectedOption, equals(randomChoice));
      });

      test('given `answerStatus` is depleted, returns null', () {
        final randomChoice =
            OptionIndex.values[Random().nextInt(OptionIndex.values.length)];
        final state = QuizState(
          selectedOption: randomChoice,
          answerStatus: AnswerStatus.depleted,
        );
        expect(state.selectedOption, isNull);
      });
    });

    group('[CopyWith]', () {
      test('returns same object when no params passed', () {
        expect(const QuizState().copyWith(), const QuizState());
      });

      test('given [quiz] param passed, returns object with updated quiz', () {
        expect(
          const QuizState().copyWith(quiz: mockQuiz),
          const QuizState(quiz: mockQuiz),
        );
      });

      test(
        'given [quizQuestions] param passed, returns object with updated quizQuestions',
        () {
          expect(
            const QuizState().copyWith(quizQuestions: SeedData.wowQuestions),
            const QuizState(quizQuestions: SeedData.wowQuestions),
          );
        },
      );

      test(
        'given [answers] param passed, returns object with updated answers',
        () {
          expect(
            const QuizState().copyWith(answers: mockAnswers),
            const QuizState(answers: mockAnswers),
          );
        },
      );

      test('given [score] param passed, returns object with updated score', () {
        expect(
          const QuizState().copyWith(score: 32),
          const QuizState(score: 32),
        );
      });

      test(
        'given [questionIndex] param passed, returns object with updated questionIndex',
        () {
          expect(
            const QuizState().copyWith(questionIndex: 2),
            const QuizState(questionIndex: 2),
          );
        },
      );

      test(
          'given [answerStatus] param passed, returns object with updated answerStatus',
          () {
        expect(
          const QuizState().copyWith(answerStatus: AnswerStatus.confirmed),
          const QuizState(answerStatus: AnswerStatus.confirmed),
        );
      });

      test(
        'given [selectedOption] param passed, returns object with updated selectedOption',
        () {
          expect(
            const QuizState().copyWith(selectedOption: OptionIndex.C),
            const QuizState(selectedOption: OptionIndex.C),
          );
        },
      );

      test(
        'given [status] param passed, returns object with updated status',
        () {
          expect(
            const QuizState().copyWith(status: QuizStatus.complete),
            const QuizState(status: QuizStatus.complete),
          );
        },
      );

      test(
        'given [status] param passed, returns object with updated status',
        () {
          expect(
            const QuizState()
                .copyWith(loadingStatus: FormzSubmissionStatus.inProgress),
            const QuizState(loadingStatus: FormzSubmissionStatus.inProgress),
          );
        },
      );

      test(
        'given [error] param passed, returns object with updated error',
        () {
          final exceptionString = Exception('test error').toString();
          expect(
            const QuizState().copyWith(error: exceptionString),
            QuizState(error: exceptionString),
          );
        },
      );
    });
  });
}
