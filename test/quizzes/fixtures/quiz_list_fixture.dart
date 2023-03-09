import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/widgets/quiz_list.dart';

class QuizListFixture extends StatelessWidget {
  const QuizListFixture({
    Key? key,
    required QuizzesCubit cubit,
  })  : _cubit = cubit,
        super(key: key);

  final QuizzesCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizzesCubit>.value(
      value: _cubit,
      child: const MaterialApp(
        home: QuizList(),
      ),
    );
  }
}
