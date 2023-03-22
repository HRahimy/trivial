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
        'given [choiceSelected] param passed, returns object with updated choiceSelected',
        () {
          expect(
            const QuizState().copyWith(choiceSelected: true),
            const QuizState(choiceSelected: true),
          );
        },
      );

      test(
        'given [questionDepleted] param passed, returns object with updated questionDepleted',
        () {
          expect(
            const QuizState().copyWith(questionDepleted: true),
            const QuizState(questionDepleted: true),
          );
        },
      );

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
        'given [complete] param passed, returns object with updated complete',
        () {
          expect(
            const QuizState().copyWith(complete: true),
            const QuizState(complete: true),
          );
        },
      );

      test(
        'given [status] param passed, returns object with updated status',
        () {
          expect(
            const QuizState()
                .copyWith(status: FormzSubmissionStatus.inProgress),
            const QuizState(status: FormzSubmissionStatus.inProgress),
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
