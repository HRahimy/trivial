import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/widgets/quiz_screen.dart';

import '../../mocks/quiz_cubit_mock.dart';

class LoadableQuizScreenFixture extends StatelessWidget {
  LoadableQuizScreenFixture({
    super.key,
    QuizCubit? cubit,
  }) : _cubit = cubit ?? QuizCubitMock();

  final QuizCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizCubit>.value(
      value: _cubit,
      child: const MaterialApp(
        home: LoadableQuizScreen(),
      ),
    );
  }
}
