import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';
import 'package:trivial/quiz/widgets/quiz_running_body.dart';
import 'package:trivial/theme.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../tests_navigator_observer.dart';
import '../fixtures/loaded_quiz_screen_fixture.dart';

void main() {
  late TestsNavigatorObserver navObserver;
  late QuizCubit cubit;
  const QuizState loadedState = QuizState(
    quiz: SeedData.wowQuiz,
    quizQuestions: SeedData.wowQuestions,
    questionIndex: 1,
    status: QuizStatus.started,
    loadingStatus: FormzSubmissionStatus.success,
  );
  setUp(() {
    cubit = QuizCubitMock();
    navObserver = TestsNavigatorObserver();
  });

  group('[QuizBody] while running ', () {
    testWidgets('given `state.status` is not started, quiz body does not exist',
        (tester) async {
      final possibleStatuses = QuizStatus.values
          .where((element) => element != QuizStatus.started)
          .toList();
      for (var status in possibleStatuses) {
        when(() => cubit.state).thenReturn(QuizState(status: status));

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        expect(find.byKey(QuizKeys.quizRunningBody), findsNothing);
      }
    });
    testWidgets('given `state.status` is started, quiz body exists',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState);

      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
      ));

      final bodyFinder = find.byKey(QuizKeys.quizRunningBody);
      expect(bodyFinder, findsOneWidget);
      expect(find.byKey(QuizKeys.quizEndBody), findsNothing);
      expect(find.byKey(QuizKeys.quizStartMenu), findsNothing);

      final widget = tester.widget(bodyFinder);
      expect(widget.runtimeType, equals(QuizRunningBody));
    });

    group('[QuestionPanel]', () {
      testWidgets('question text section exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        //region question section
        final sectionFinder = find.descendant(
          of: find.byKey(QuizKeys.quizRunningBody),
          matching: find.byKey(
              QuizKeys.questionPanel('${loadedState.currentQuestion.id}')),
        );
        expect(sectionFinder, findsOneWidget);
        //endregion

        //region question text
        final textFinder = find.descendant(
          of: sectionFinder,
          matching: find.byKey(
              QuizKeys.questionText('${loadedState.currentQuestion.id}')),
        );
        expect(textFinder, findsOneWidget);
        //endregion
      });

      testWidgets('question text is correct', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final widget = tester.widget(find.byKey(
                QuizKeys.questionText('${loadedState.currentQuestion.id}')))
            as Text;
        expect(
          widget.data,
          equals(loadedState.currentQuestion.question),
        );
      });
    });

    group('[Timer]', () {
      testWidgets('widget exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

      testWidgets('timer goes down', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

      testWidgets(
          'given timer is depleted, `depleteQuestion()` event is called in state',
          (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        await tester.pumpAndSettle();

        verify(() => cubit.depleteQuestion()).called(1);
      });

      testWidgets('timer is 15 seconds ', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));
        final finder = find.descendant(
          of: find.byKey(QuizKeys.quizRunningBody),
          matching: find.byKey(QuizKeys.scorePanel),
        );
        expect(finder, findsOneWidget);
      });

      testWidgets('score panel text exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

        await tester.pumpWidget(LoadedQuizScreenFixture(
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

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        expect(
          find.byKey(
              QuizKeys.optionsPanel('${loadedState.currentQuestion.id}')),
          findsOneWidget,
        );
      });

      testWidgets('panel contains option buttons', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final panelFinder = find
            .byKey(QuizKeys.optionsPanel('${loadedState.currentQuestion.id}'));
        final aFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(
              QuizKeys.optionAButton('${loadedState.currentQuestion.id}')),
        );
        final bFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(
              QuizKeys.optionBButton('${loadedState.currentQuestion.id}')),
        );
        final cFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(
              QuizKeys.optionCButton('${loadedState.currentQuestion.id}')),
        );
        final dFinder = find.descendant(
          of: panelFinder,
          matching: find.byKey(
              QuizKeys.optionDButton('${loadedState.currentQuestion.id}')),
        );

        expect(aFinder, findsOneWidget);
        expect(bFinder, findsOneWidget);
        expect(cFinder, findsOneWidget);
        expect(dFinder, findsOneWidget);
      });

      group('[OptionAButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
              QuizKeys.optionAButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionAButtonText(
                '${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('A) ${loadedState.currentQuestion.options[OptionIndex.A]}'),
          );
        });

        testWidgets('given option A is selected, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.A,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionAButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given option A is selected and question is depleted, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.A,
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionAButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given question is NOT depleted, pressing button triggers select event in state',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: false,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionAButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          await tester.tap(inkwellFinder);
          verify(() => cubit.selectAnswer(OptionIndex.A)).called(1);
        });

        testWidgets(
            'given option A is NOT selected and question is depleted, button is greyed and disabled',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionAButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(Colors.grey[300]));

          await tester.tap(inkwellFinder);
          verifyNever(() => cubit.selectAnswer(OptionIndex.A));
        });
      });

      group('[OptionBButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
              QuizKeys.optionBButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionBButtonText(
                '${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('B) ${loadedState.currentQuestion.options[OptionIndex.B]}'),
          );
        });

        testWidgets('given option B is selected, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.B,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionBButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given option B is selected and question is depleted, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.B,
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionBButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given question is NOT depleted, pressing button triggers select event in state',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: false,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionBButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          await tester.tap(inkwellFinder);
          verify(() => cubit.selectAnswer(OptionIndex.B)).called(1);
        });

        testWidgets(
            'given option B is NOT selected and question is depleted, button is greyed and disabled',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionBButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(Colors.grey[300]));

          await tester.tap(inkwellFinder);
          verifyNever(() => cubit.selectAnswer(OptionIndex.B));
        });
      });

      group('[OptionCButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
              QuizKeys.optionCButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionCButtonText(
                '${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('C) ${loadedState.currentQuestion.options[OptionIndex.C]}'),
          );
        });

        testWidgets('given option C is selected, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.C,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionCButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given option C is selected and question is depleted, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.C,
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionCButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given question is NOT depleted, pressing button triggers select event in state',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: false,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionCButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          await tester.tap(inkwellFinder);
          verify(() => cubit.selectAnswer(OptionIndex.C)).called(1);
        });

        testWidgets(
            'given option C is NOT selected and question is depleted, button is greyed and disabled',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionCButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(Colors.grey[300]));

          await tester.tap(inkwellFinder);
          verifyNever(() => cubit.selectAnswer(OptionIndex.C));
        });
      });

      group('[OptionDButton]', () {
        testWidgets('contains text and is correct', (tester) async {
          when(() => cubit.state).thenReturn(loadedState);

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
              QuizKeys.optionDButton('${loadedState.currentQuestion.id}'));
          final textFinder = find.descendant(
            of: buttonFinder,
            matching: find.byKey(QuizKeys.optionDButtonText(
                '${loadedState.currentQuestion.id}')),
          );
          final textWidget = tester.widget(textFinder) as Text;

          expect(textFinder, findsOneWidget);
          expect(
            textWidget.data,
            equals('D) ${loadedState.currentQuestion.options[OptionIndex.D]}'),
          );
        });

        testWidgets('given option D is selected, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.D,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionDButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given option D is selected and question is depleted, button is highlighted',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            choiceSelected: true,
            selectedOption: OptionIndex.D,
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionDButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );

          expect(materialFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(AppTheme.complementaryColor));
        });

        testWidgets(
            'given question is NOT depleted, pressing button triggers select event in state',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: false,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionDButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          await tester.tap(inkwellFinder);
          verify(() => cubit.selectAnswer(OptionIndex.D)).called(1);
        });

        testWidgets(
            'given option D is NOT selected and question is depleted, button is greyed and disabled',
            (tester) async {
          when(() => cubit.state).thenReturn(loadedState.copyWith(
            questionDepleted: true,
          ));

          await tester.pumpWidget(LoadedQuizScreenFixture(
            quizCubit: cubit,
          ));

          final buttonFinder = find.byKey(
            QuizKeys.optionDButton('${loadedState.currentQuestion.id}'),
          );
          final materialFinder = find.descendant(
            of: buttonFinder,
            matching: find.byType(Material),
          );
          final inkwellFinder = find.descendant(
            of: materialFinder,
            matching: find.byType(InkWell),
          );

          expect(materialFinder, findsOneWidget);
          expect(inkwellFinder, findsOneWidget);

          final materialWidget = tester.widget(materialFinder) as Material;
          expect(materialWidget.color, equals(Colors.grey[300]));

          await tester.tap(inkwellFinder);
          verifyNever(() => cubit.selectAnswer(OptionIndex.D));
        });
      });
    });

    group('[ContinueButton]', () {
      testWidgets('widget exists', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';

        expect(
          find.byKey(QuizKeys.continueButton(buttonId)),
          findsOneWidget,
        );
      });

      testWidgets('text exists and is correct', (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';

        final textFinder = find.descendant(
          of: find.byKey(QuizKeys.continueButton(buttonId)),
          matching: find.byKey(QuizKeys.continueButtonText(buttonId)),
        );

        expect(textFinder, findsOneWidget);

        final textWidget = tester.widget(textFinder);

        expect(textWidget.runtimeType, equals(Text));
        expect((textWidget as Text).data, equals('CONTINUE'));
      });

      testWidgets('given question is in initial state, button is disabled',
          (tester) async {
        when(() => cubit.state).thenReturn(loadedState);

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';

        final button =
            tester.widget(find.byKey(QuizKeys.continueButton(buttonId)))
                as ElevatedButton;

        expect(button.enabled, equals(false));
      });

      testWidgets('given option is selected, button is enabled',
          (tester) async {
        when(() => cubit.state).thenReturn(loadedState.copyWith(
          choiceSelected: true,
          selectedOption: OptionIndex.C,
        ));

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';

        final button =
            tester.widget(find.byKey(QuizKeys.continueButton(buttonId)))
                as ElevatedButton;

        expect(button.enabled, equals(true));
      });

      testWidgets('given question is depleted, button is enabled',
          (tester) async {
        when(() => cubit.state).thenReturn(loadedState.copyWith(
          questionDepleted: true,
        ));

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';

        final button =
            tester.widget(find.byKey(QuizKeys.continueButton(buttonId)))
                as ElevatedButton;

        expect(button.enabled, equals(true));
      });

      testWidgets(
          'given button is enabled, pressing button triggers continue event in state',
          (tester) async {
        when(() => cubit.state).thenReturn(loadedState.copyWith(
          questionDepleted: true,
        ));

        await tester.pumpWidget(LoadedQuizScreenFixture(
          quizCubit: cubit,
        ));

        final String buttonId = '${loadedState.currentQuestion.id}';
        final buttonFinder = find.byKey(QuizKeys.continueButton(buttonId));

        await tester.tap(buttonFinder);
        verify(() => cubit.continueQuiz()).called(1);
      });
    });
  });

  group('[Abort]', () {
    testWidgets(
        'given quiz is not complete, button and components are rendered',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith(
        status: QuizStatus.started,
      ));

      await tester.pumpWidget(LoadedQuizScreenFixture(quizCubit: cubit));

      final buttonFinder = find.byKey(QuizKeys.abortButton);
      // final iconFinder = find.descendant(
      //   of: buttonFinder,
      //   matching: find.byKey(QuizKeys.abortButtonIcon),
      // );
      final textFinder = find.descendant(
        of: buttonFinder,
        matching: find.byKey(QuizKeys.abortButtonText),
      );

      expect(buttonFinder, findsOneWidget);
      // expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);

      final buttonWidget = tester.widget(buttonFinder);
      // final iconWidget = tester.widget(iconFinder);
      final textWidget = tester.widget(textFinder);

      expect(buttonFinder, findsOneWidget);
      expect(
        buttonWidget.runtimeType,
        FloatingActionButton,
        reason: 'design requires floating action button',
      );

      // expect(iconWidget, findsOneWidget);
      // expect(iconWidget.runtimeType, Icon);

      expect(textFinder, findsOneWidget);
      expect(textWidget.runtimeType, Text);
    });

    testWidgets('given quiz is complete, button does not exist',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith(
        status: QuizStatus.complete,
      ));

      await tester.pumpWidget(LoadedQuizScreenFixture(quizCubit: cubit));

      final buttonFinder = find.byKey(QuizKeys.abortButton);
      final iconFinder = find.descendant(
        of: buttonFinder,
        matching: find.byKey(QuizKeys.abortButtonIcon),
      );
      final textFinder = find.descendant(
        of: buttonFinder,
        matching: find.byKey(QuizKeys.abortButtonText),
      );

      expect(buttonFinder, findsNothing);
      expect(iconFinder, findsNothing);
      expect(textFinder, findsNothing);
    });

    testWidgets('pressing abort button opens up confirmation dialog',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith(
        status: QuizStatus.started,
      ));

      await tester.pumpWidget(LoadedQuizScreenFixture(quizCubit: cubit));

      await tester.tap(find.byKey(QuizKeys.abortButton));

      await tester.pumpAndSettle();

      final finder = find.byKey(QuizKeys.abortDialog);

      expect(finder, findsOneWidget);

      final widget = tester.widget(finder);

      expect(widget.runtimeType, equals(AbortConfirmDialog));
    });

    testWidgets('tapping outside the alert dialog closes it', (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith(
        status: QuizStatus.started,
      ));

      await tester.pumpWidget(LoadedQuizScreenFixture(quizCubit: cubit));

      await tester.tap(find.byKey(QuizKeys.abortButton));

      await tester.pumpAndSettle();

      final finder = find.byKey(QuizKeys.abortDialog);

      expect(finder, findsOneWidget);

      await tester.tapAt(const Offset(1, 1));

      await tester.pumpAndSettle();

      expect(finder, findsNothing);
    });

    testWidgets('pressing accept button triggers two navigation pops',
        (tester) async {
      when(() => cubit.state).thenReturn(loadedState.copyWith(
        status: QuizStatus.started,
      ));
      await tester.pumpWidget(LoadedQuizScreenFixture(
        quizCubit: cubit,
      ));

      await tester.tap(find.byKey(QuizKeys.abortButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(QuizKeys.abortDialogAcceptButton));
      await tester.pumpAndSettle();

      verify(() => cubit.restartQuiz()).called(1);
    });
  });
}
