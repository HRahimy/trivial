import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<QuizCubit, QuizState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.complete != current.complete,
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress ||
              state.status == FormzSubmissionStatus.initial) {
            return const CircularProgressIndicator();
          } else if (state.status == FormzSubmissionStatus.failure) {
            return Text(state.error);
          } else {
            return state.complete ? const _EndLayout() : const _Layout();
          }
        },
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(
          flex: 7,
          child: _QuestionPanel(),
        ),
        Divider(
          thickness: 5,
          height: 0,
        ),
        Expanded(
          flex: 1,
          child: _ScorePanel(),
        ),
        Divider(
          thickness: 2,
          height: 0,
        ),
        Expanded(
          flex: 7,
          child: _OptionsGrid(),
        ),
      ],
    );
  }
}

class _QuestionPanel extends StatelessWidget {
  const _QuestionPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<QuizCubit, QuizState>(
        buildWhen: (previous, current) =>
            previous.questionIndex != current.questionIndex,
        builder: (context, state) {
          return Text(
            state.currentQuestion.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          );
        },
      ),
    );
  }
}

class _ScorePanel extends StatelessWidget {
  const _ScorePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<QuizCubit, QuizState>(
        buildWhen: (previous, current) => previous.score != current.score,
        builder: (context, state) {
          return Text(
            'Level ${state.score}',
            style: const TextStyle(
              fontSize: 18,
            ),
          );
        },
      ),
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  const _OptionsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) =>
          previous.questionIndex != current.questionIndex,
      builder: (context, state) {
        final question = state.currentQuestion;
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _OptionButton(
                      text: 'A) ${question.options[OptionIndex.A]!}',
                      onTap: () => cubit.selectAnswer(OptionIndex.A),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 1,
                  ),
                  Expanded(
                    child: _OptionButton(
                      text: 'A) ${question.options[OptionIndex.B]!}',
                      onTap: () => cubit.selectAnswer(OptionIndex.B),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _OptionButton(
                      text: 'A) ${question.options[OptionIndex.C]!}',
                      onTap: () => cubit.selectAnswer(OptionIndex.C),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 1,
                  ),
                  Expanded(
                    child: _OptionButton(
                      text: 'A) ${question.options[OptionIndex.D]!}',
                      onTap: () => cubit.selectAnswer(OptionIndex.D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    Key? key,
    this.onTap,
    required this.text,
  }) : super(key: key);
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}

class _EndLayout extends StatelessWidget {
  const _EndLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              return Text(
                'You reached level ${state.score}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => context.read<QuizCubit>().loadQuiz(),
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Goodbye'),
          ),
        ],
      ),
    );
  }
}
