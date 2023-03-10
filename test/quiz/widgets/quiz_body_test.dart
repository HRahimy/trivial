import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';

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
  setUp(() {
    cubit = QuizCubitMock();
  });

  group('[QuizBody] while running ', () {
    testWidgets('quiz body exists', (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      await tester.pumpWidget(QuizBodyFixture(
        quizCubit: cubit,
      ));

      expect(find.byKey(QuizKeys.quizBody), findsOneWidget);
    });

    group('[QuestionPanel]', () {
      testWidgets('question text section exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));
        final finder = find.descendant(
          of: find.byKey(QuizKeys.quizBody),
          matching: find.byKey(
              QuizKeys.questionPanel('${loadedState.currentQuestion.id}')),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('question text exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));
        final finder = find.descendant(
          of: find.byKey(
              QuizKeys.questionPanel('${loadedState.currentQuestion.id}')),
          matching: find.byKey(
              QuizKeys.questionText('${loadedState.currentQuestion.id}')),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('question text is correct', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final widget = tester.widget(find.byKey(QuizKeys.questionText('${loadedState.currentQuestion.id}'))) as Text;
        expect(
          widget.data,
          equals(loadedState.currentQuestion.question),
        );
      });
    });

    group('[Timer]', () {
      testWidgets('widget exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final animationFinder = find.descendant(
          of: find.byKey(
              QuizKeys.questionTimer('${loadedState.currentQuestion.id}')),
          matching: find.byType(AnimatedBuilder),
        );
        final progressIndicatorFinder = find.descendant(
          of: animationFinder,
          matching: find.byType(LinearProgressIndicator),
        );

        expect(
            find.byKey(
                QuizKeys.questionTimer('${loadedState.currentQuestion.id}')),
            findsOneWidget);
        expect(animationFinder, findsOneWidget);
        expect(progressIndicatorFinder, findsOneWidget);
      });

      testWidgets('timer starts full', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final animationFinder = find.descendant(
          of: find.byKey(
              QuizKeys.questionTimer('${loadedState.currentQuestion.id}')),
          matching: find.byType(AnimatedBuilder),
        );
        final progressIndicatorFinder = find.descendant(
          of: animationFinder,
          matching: find.byType(LinearProgressIndicator),
        );
        final progressWidget =
            tester.widget(progressIndicatorFinder) as LinearProgressIndicator;

        expect(progressWidget.value, equals(1.0));
      });

      testWidgets('timer goes down ', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        await tester.pumpAndSettle();

        final animationFinder = find.descendant(
          of: find.byKey(
              QuizKeys.questionTimer('${loadedState.currentQuestion.id}')),
          matching: find.byType(AnimatedBuilder),
        );
        final progressIndicatorFinder = find.descendant(
          of: animationFinder,
          matching: find.byType(LinearProgressIndicator),
        );
        final progressWidget =
            tester.widget(progressIndicatorFinder) as LinearProgressIndicator;

        expect(progressWidget.value, equals(0.0));
      });

      testWidgets('timer goes down ', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        await tester.pumpAndSettle();

        verify(() => cubit.depleteQuestion()).called(1);
      });

      testWidgets('timer is 15 seconds ', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final animationWidget = tester.widget(find.descendant(
          of: find.byKey(
              QuizKeys.questionTimer('${loadedState.currentQuestion.id}')),
          matching: find.byType(AnimatedBuilder),
        )) as AnimatedBuilder;
        final controller = animationWidget.listenable as AnimationController;

        expect(controller.duration, isNotNull);
        expect(controller.duration!.inSeconds, equals(15));
      });
    });

    group('[ScorePanel]', () {
      testWidgets('score panel exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));
        final finder = find.descendant(
          of: find.byKey(QuizKeys.quizBody),
          matching: find.byKey(QuizKeys.scorePanel),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('score panel text exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));
        final finder = find.descendant(
          of: find.byKey(QuizKeys.scorePanel),
          matching: find.byKey(QuizKeys.scoreText),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('score panel shows correct text', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final widget = tester.widget(find.byKey(QuizKeys.scoreText)) as Text;
        expect(
          widget.data,
          equals('Level ${loadedState.score}'),
        );
      });
    });

    group('[Options Panel]', () {
      testWidgets('options panel exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        expect(find.byKey(QuizKeys.optionsPanel('${loadedState.currentQuestion.id}')), findsOneWidget);
      });

      testWidgets('panel contains option buttons', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(QuizBodyFixture(
          quizCubit: cubit,
        ));

        final panelFinder = find.byKey(QuizKeys.optionsPanel('${loadedState.currentQuestion.id}'));
        final aFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(QuizKeys.optionAButton('${loadedState.currentQuestion.id}')),
        );
        final bFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(QuizKeys.optionBButton('${loadedState.currentQuestion.id}')),
        );
        final cFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(QuizKeys.optionCButton('${loadedState.currentQuestion.id}')),
        );
        final dFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(QuizKeys.optionDButton('${loadedState.currentQuestion.id}')),
        );

        expect(aFinder, findsOneWidget);
        expect(bFinder, findsOneWidget);
        expect(cFinder, findsOneWidget);
        expect(dFinder, findsOneWidget);
      });

      group('[OptionAButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(QuizBodyFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(QuizKeys.optionAButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionAButtonText('${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('A) ${loadedState.currentQuestion.options[OptionIndex.A]}'),
          );
        });
      });

      group('[OptionBButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(QuizBodyFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(QuizKeys.optionBButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionBButtonText('${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('B) ${loadedState.currentQuestion.options[OptionIndex.B]}'),
          );
        });
      });

      group('[OptionCButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(QuizBodyFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(QuizKeys.optionCButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionCButtonText('${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('C) ${loadedState.currentQuestion.options[OptionIndex.C]}'),
          );
        });
      });

      group('[OptionDButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(QuizBodyFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(QuizKeys.optionDButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionDButtonText('${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('D) ${loadedState.currentQuestion.options[OptionIndex.D]}'),
          );
        });
      });
    });
  });
}
