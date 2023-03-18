import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';

void main() {
  group('[QuizzesState]', () {
    test('supports value comparisons', () {
      expect(const QuizzesState(), const QuizzesState());
    });

    group('[CopyWith]', () {
      test('returns same object when no values are passed', () {
        expect(const QuizzesState().copyWith(), const QuizzesState());
      });

      test('returns object with updated quizzes when quizzes param is passed',
          () {
        const Quiz newQuiz = Quiz(id: 444, name: 'newQuiz');

        expect(
          const QuizzesState().copyWith(quizzes: [newQuiz]),
          const QuizzesState(quizzes: [newQuiz]),
        );
      });

      test('returns object with updated status when status param is passed',
          () {
        expect(
          const QuizzesState()
              .copyWith(status: FormzSubmissionStatus.inProgress),
          const QuizzesState(status: FormzSubmissionStatus.inProgress),
        );
      });

      test('returns object with updated error when error param is passed', () {
        expect(
          const QuizzesState().copyWith(error: 'test error'),
          const QuizzesState(error: 'test error'),
        );
      });
    });
  });
}
