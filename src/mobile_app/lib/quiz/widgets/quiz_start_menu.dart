import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';

class QuizStartMenu extends StatelessWidget {
  const QuizStartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: _TextSection(),
            ),
            Expanded(
              flex: 1,
              child: _ButtonSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<QuizCubit>().state;
    final topScore = state.quizQuestions
        .map((e) => e.points)
        .fold(0, (previous, current) => previous + current);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.quiz.name,
          key: QuizKeys.startMenuTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        Text(
          state.quiz.description,
          key: QuizKeys.startMenuDescriptionText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const Divider(height: 48, thickness: 2),
        Text(
          '${state.quizQuestions.length} questions',
          key: QuizKeys.startMenuQuestionsText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        Text(
          'Get a top score of $topScore',
          key: QuizKeys.startMenuScoreText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _ButtonSection extends StatelessWidget {
  const _ButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalDirection: VerticalDirection.up,
      children: [
        TextButton(
          key: QuizKeys.startMenuBackButton,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Back',
            key: QuizKeys.startMenuBackButtonText,
          ),
        ),
        ElevatedButton(
          key: QuizKeys.startMenuPlayButton,
          onPressed: () => cubit.startQuiz(),
          child: const Text(
            'Play',
            key: QuizKeys.startMenuPlayButtonText,
          ),
        ),
      ],
    );
  }
}
