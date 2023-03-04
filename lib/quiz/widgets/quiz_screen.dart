import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

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
      child: const Scaffold(
        body: _View(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state.status == FormzSubmissionStatus.inProgress ||
                state.status == FormzSubmissionStatus.initial) {
              return const CircularProgressIndicator();
            } else if (state.status == FormzSubmissionStatus.failure) {
              return Text(state.error);
            } else {
              return Text(state.quiz.name);
            }
          },
        ),
      ),
    );
  }
}
