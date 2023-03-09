import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../fixtures/quiz_body_fixture.dart';

void main() {
  late QuizCubit cubit;
  const QuizState loadedState = QuizState(
    quiz: SeedData.wowQuiz,
    quizQuestions: SeedData.wowQuestions,
    questionIndex: 1,
    status: FormzSubmissionStatus.success,
  );
  group('[QuizBody]', () {
    setUp(() {
      cubit = QuizCubitMock();
    });

    testWidgets('question text exists', (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      await tester.pumpWidget(QuizBodyFixture(
        quizCubit: cubit,
      ));
    });
  });
}
