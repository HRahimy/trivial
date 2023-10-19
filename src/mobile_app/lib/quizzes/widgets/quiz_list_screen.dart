import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/widgets/quiz_list.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({Key? key}) : super(key: key);
  static const String routeName = '/quizList';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizzesCubit(
        quizRepository: RepositoryProvider.of<QuizRepository>(context),
      )..loadInitial(),
      child: const QuizList(),
    );
  }
}
