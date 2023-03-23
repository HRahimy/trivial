import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/widgets/quiz_body.dart';

class QuizScreenArgs extends Equatable {
  const QuizScreenArgs({required this.quizId});

  final int quizId;

  @override
  List<Object> get props => [quizId];
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  static const String routeName = '/quizScreen';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as QuizScreenArgs;

    return BlocProvider(
      create: (_) => QuizCubit(
        quizId: args.quizId,
        quizRepository: RepositoryProvider.of<QuizRepository>(context),
      )..loadQuiz(),
      child: const QuizBody(),
    );
  }
}
