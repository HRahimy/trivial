import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/quiz_screen.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../fixtures/loadable_quiz_screen_fixture.dart';

void main() {
  late QuizCubit cubit;
  setUp(() {
    cubit = QuizCubitMock();
  });
  group('[LoadableQuizScreen]', () {
    group('given `loadStatus` is not success', () {
      final possibleStatuses = FormzSubmissionStatus.values
          .where((element) => element != FormzSubmissionStatus.success)
          .toList();
      for (var status in possibleStatuses) {
        testWidgets('with `loadStatus` being ${status.toString()}',
            (tester) async {
          when(() => cubit.state).thenReturn(QuizState(
            loadingStatus: status,
          ));
          await tester.pumpWidget(LoadableQuizScreenFixture(cubit: cubit));

          expect(find.byKey(QuizKeys.loadedQuizScreen), findsNothing);
          expect(find.byType(LoadedQuizScreen), findsNothing);
        });
      }
    });

    testWidgets('given `loadStatus` is initial, shows greyed out screen',
        (tester) async {
      when(() => cubit.state).thenReturn(const QuizState(
        loadingStatus: FormzSubmissionStatus.initial,
      ));
      await tester.pumpWidget(LoadableQuizScreenFixture(cubit: cubit));

      final scaffoldFinder = find.byType(Scaffold);
      final scaffoldWidget = tester.widget(scaffoldFinder);

      expect(scaffoldFinder, findsOneWidget);
      expect(scaffoldWidget.runtimeType, equals(Scaffold));
      expect((scaffoldWidget as Scaffold).backgroundColor, equals(Colors.grey));
    });

    testWidgets(
        'given `loadStatus` is submissionInProgress, shows centered progress indicator',
        (tester) async {
      when(() => cubit.state).thenReturn(const QuizState(
        loadingStatus: FormzSubmissionStatus.inProgress,
      ));
      await tester.pumpWidget(LoadableQuizScreenFixture(cubit: cubit));

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.ancestor(
        of: progressFinder,
        matching: find.byType(Center),
      );

      expect(progressFinder, findsOneWidget);
      expect(centerFinder, findsOneWidget);
    });
  });
}
