import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

void main() {
  group('[QuizState]', () {
    test('supports value comparisons', () {
      expect(const QuizState(), const QuizState());
    });

    group('[CopyWith]', () {
      test('returns same object when no params passed', () {
        expect(const QuizState().copyWith(), const QuizState());
      });
    });
  });
}
