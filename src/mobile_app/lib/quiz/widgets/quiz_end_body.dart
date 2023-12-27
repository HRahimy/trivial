import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/common/widgets/twinkle_container.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';

class QuizEndBody extends StatelessWidget {
  const QuizEndBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _EndLayout(),
    );
  }
}

class _EndLayout extends StatelessWidget {
  const _EndLayout({Key? key}) : super(key: key);

  Column _flavorTextSection(BuildContext context) {
    return Column(
      key: QuizKeys.quizEndFlavorTextSection,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Congratulations!',
          key: QuizKeys.quizEndFlavorText,
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
              key: QuizKeys.quizEndScoreText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            );
          },
        ),
      ],
    );
  }

  Column _controls(BuildContext context) {
    return Column(
      key: QuizKeys.quizEndControlsSection,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          key: QuizKeys.tryAgainButton,
          onPressed: () => context.read<QuizCubit>().restartQuiz(),
          child: const Text(
            'Try Again!',
            key: QuizKeys.tryAgainButtonText,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        ElevatedButton(
          key: QuizKeys.goodbyeButton,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Goodbye!',
            key: QuizKeys.goodbyeButtonText,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TwinkleContainer(
      key: QuizKeys.twinkleContainer,
      spawnAreaHeight: MediaQuery.of(context).size.height / 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _flavorTextSection(context),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            _controls(context),
          ],
        ),
      ),
    );
  }
}
