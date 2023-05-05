import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

import '../../mocks/quiz_cubit_mock.dart';

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
        });
      }
    });
  });
}
