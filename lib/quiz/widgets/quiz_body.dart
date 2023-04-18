import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/common/widgets/twinkle_container.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/theme.dart';

class QuizBody extends StatelessWidget {
  const QuizBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              return state.complete
                  ? const _EndLayout(
                      key: QuizKeys.quizEndBody,
                    )
                  : const _Layout(
                      key: QuizKeys.quizBody,
                    );
            }
          },
        ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 8,
          child: BlocBuilder<QuizCubit, QuizState>(
            buildWhen: (previous, current) =>
                previous.questionIndex != current.questionIndex,
            builder: (context, state) {
              return _QuestionPanel(
                key: QuizKeys.questionPanel('${state.currentQuestion.id}'),
                question: state.currentQuestion,
              );
            },
          ),
        ),
        const _TimerBuilder(),
        const Divider(
          thickness: 5,
          height: 0,
        ),
        Expanded(
          flex: 1,
          child: BlocBuilder<QuizCubit, QuizState>(
            buildWhen: (previous, current) => previous.score != current.score,
            builder: (context, state) {
              return _ScorePanel(
                key: QuizKeys.scorePanel,
                score: '${state.score}',
              );
            },
          ),
        ),
        const Divider(
          thickness: 2,
          height: 0,
        ),
        const Expanded(
          flex: 8,
          child: _OptionsGrid(),
        ),
        const Divider(
          thickness: 2,
          height: 0,
        ),
        const Expanded(
          flex: 2,
          child: _ContinueButton(),
        ),
      ],
    );
  }
}

class _QuestionPanel extends StatelessWidget {
  const _QuestionPanel({
    Key? key,
    required this.question,
  }) : super(key: key);
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          question.question,
          key: QuizKeys.questionText('${question.id}'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _TimerBuilder extends StatelessWidget {
  const _TimerBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) =>
          previous.questionIndex != current.questionIndex,
      builder: (context, state) {
        return _Timer(
          key: QuizKeys.questionTimer('${state.currentQuestion.id}'),
        );
      },
    );
  }
}

class _Timer extends StatefulWidget {
  const _Timer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimerState();
}

class _TimerState extends State<_Timer> with TickerProviderStateMixin {
  AnimationController? controller;
  static const int durationSeconds = 15;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: durationSeconds),
    );
    controller!.reverse(from: durationSeconds.toDouble());
    controller!.addStatusListener(listener);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void listener(AnimationStatus status) {
    if (controller!.isDismissed) {
      context.read<QuizCubit>().depleteQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: controller!.value,
          minHeight: 16,
          backgroundColor: AppTheme().primarySwatch.withOpacity(0.3),
        );
      },
    );
  }
}

class _ScorePanel extends StatelessWidget {
  const _ScorePanel({
    Key? key,
    required this.score,
  }) : super(key: key);

  final String score;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Level $score',
        key: QuizKeys.scoreText,
        style: const TextStyle(
          fontSize: 18,
        ),
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
          previous.questionIndex != current.questionIndex ||
          previous.selectedOption != current.selectedOption ||
          previous.questionDepleted != current.questionDepleted,
      builder: (context, state) {
        final question = state.currentQuestion;
        return Column(
          key: QuizKeys.optionsPanel('${state.currentQuestion.id}'),
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _OptionButton(
                      question: question.options[OptionIndex.A]!,
                      option: OptionIndex.A,
                      questionId: '${question.id}',
                      key: QuizKeys.optionAButton('${question.id}'),
                      onTap: !state.questionDepleted
                          ? () => cubit.selectAnswer(OptionIndex.A)
                          : null,
                      status: state.selectedOption == OptionIndex.A
                          ? _OptionButtonStatus.selected
                          : state.questionDepleted
                              ? _OptionButtonStatus.disabled
                              : _OptionButtonStatus.initial,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 1,
                  ),
                  Expanded(
                    child: _OptionButton(
                      question: question.options[OptionIndex.B]!,
                      option: OptionIndex.B,
                      questionId: '${question.id}',
                      key: QuizKeys.optionBButton('${question.id}'),
                      onTap: !state.questionDepleted
                          ? () => cubit.selectAnswer(OptionIndex.B)
                          : null,
                      status: state.selectedOption == OptionIndex.B
                          ? _OptionButtonStatus.selected
                          : state.questionDepleted
                              ? _OptionButtonStatus.disabled
                              : _OptionButtonStatus.initial,
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
                      question: question.options[OptionIndex.C]!,
                      option: OptionIndex.C,
                      questionId: '${question.id}',
                      key: QuizKeys.optionCButton('${question.id}'),
                      onTap: !state.questionDepleted
                          ? () => cubit.selectAnswer(OptionIndex.C)
                          : null,
                      status: state.selectedOption == OptionIndex.C
                          ? _OptionButtonStatus.selected
                          : state.questionDepleted
                              ? _OptionButtonStatus.disabled
                              : _OptionButtonStatus.initial,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    width: 1,
                  ),
                  Expanded(
                    child: _OptionButton(
                      question: question.options[OptionIndex.D]!,
                      option: OptionIndex.D,
                      questionId: '${question.id}',
                      key: QuizKeys.optionDButton('${question.id}'),
                      onTap: !state.questionDepleted
                          ? () => cubit.selectAnswer(OptionIndex.D)
                          : null,
                      status: state.selectedOption == OptionIndex.D
                          ? _OptionButtonStatus.selected
                          : state.questionDepleted
                              ? _OptionButtonStatus.disabled
                              : _OptionButtonStatus.initial,
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

enum _OptionButtonStatus { initial, selected, disabled }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    Key? key,
    this.onTap,
    required this.question,
    required this.option,
    required this.questionId,
    this.status = _OptionButtonStatus.initial,
  }) : super(key: key);
  final String question;
  final OptionIndex option;
  final String questionId;
  final Function()? onTap;
  final _OptionButtonStatus status;

  Color? get _materialColor {
    switch (status) {
      case _OptionButtonStatus.initial:
        return null;
      case _OptionButtonStatus.selected:
        return AppTheme.complementaryColor;
      case _OptionButtonStatus.disabled:
        return Colors.grey[300];
    }
  }

  String get text {
    switch (option) {
      case OptionIndex.A:
        return 'A) $question';
      case OptionIndex.B:
        return 'B) $question';
      case OptionIndex.C:
        return 'C) $question';
      case OptionIndex.D:
        return 'D) $question';
    }
  }

  Key get textKey {
    switch (option) {
      case OptionIndex.A:
        return QuizKeys.optionAButtonText(questionId);
      case OptionIndex.B:
        return QuizKeys.optionBButtonText(questionId);
      case OptionIndex.C:
        return QuizKeys.optionCButtonText(questionId);
      case OptionIndex.D:
        return QuizKeys.optionDButtonText(questionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _materialColor,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            key: textKey,
            style: TextStyle(
              fontWeight: status == _OptionButtonStatus.selected
                  ? FontWeight.bold
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) =>
          previous.choiceSelected != current.choiceSelected ||
          previous.questionDepleted != current.questionDepleted,
      builder: (context, state) {
        final bool canPress = state.choiceSelected || state.questionDepleted;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                key: QuizKeys.continueButton('${state.currentQuestion.id}'),
                onPressed: canPress
                    ? () => context.read<QuizCubit>().continueQuiz()
                    : null,
                child: Text(
                  'CONTINUE',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  key: QuizKeys.continueButtonText(
                      '${state.currentQuestion.id}'),
                ),
              ),
            ),
          ],
        );
      },
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
          onPressed: () => context.read<QuizCubit>().loadQuiz(),
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
