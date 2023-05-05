import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';
import 'package:trivial/quiz/widgets/quiz_end_body.dart';
import 'package:trivial/quiz/widgets/quiz_running_body.dart';
import 'package:trivial/quiz/widgets/quiz_start_menu.dart';

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
      child: const LoadedQuizScreen(),
    );
  }
}

class LoadableQuizScreen extends StatelessWidget {
  const LoadableQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class LoadedQuizScreen extends StatelessWidget {
  const LoadedQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.loadingStatus == FormzSubmissionStatus.inProgress ||
            state.loadingStatus == FormzSubmissionStatus.initial) {
          return const CircularProgressIndicator();
        } else if (state.loadingStatus == FormzSubmissionStatus.failure) {
          return Text(state.error);
        } else {
          switch (state.status) {
            case QuizStatus.initial:
              return const QuizStartMenu(key: QuizKeys.quizStartMenu);
            case QuizStatus.started:
              return const QuizRunningBody(key: QuizKeys.quizRunningBody);
            case QuizStatus.complete:
              return const QuizEndBody(key: QuizKeys.quizEndBody);
          }
        }
      },
    );
  }
}
