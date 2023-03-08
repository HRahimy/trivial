import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/widgets/quiz_screen.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/quizzes_keys.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({Key? key}) : super(key: key);
  static const String routeName = '/quizList';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizzesCubit(
        quizRepository: RepositoryProvider.of<QuizRepository>(context),
      )..loadInitial(),
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
        child: BlocBuilder<QuizzesCubit, QuizzesState>(
          builder: (context, state) {
            if (state.status == FormzSubmissionStatus.inProgress ||
                state.status == FormzSubmissionStatus.initial) {
              return const CircularProgressIndicator();
            } else if (state.status == FormzSubmissionStatus.failure) {
              return Text(state.error);
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  key: QuizzesKeys.quizList,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.quizzes
                      .map((e) => _QuizButton(
                            key: QuizzesKeys.quizItemButton('${e.id}'),
                            quiz: e,
                          ))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _QuizButton extends StatelessWidget {
  const _QuizButton({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(
        context,
        QuizScreen.routeName,
        arguments: QuizScreenArgs(quizId: quiz.id),
      ),
      child: Text(
        quiz.name,
        key: QuizzesKeys.quizItemButtonText('${quiz.id}'),
      ),
    );
  }
}
