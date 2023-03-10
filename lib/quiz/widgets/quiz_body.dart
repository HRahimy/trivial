import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';

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
                  ? const _EndLayout()
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
          flex: 7,
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
          flex: 7,
          child: _OptionsGrid(),
        ),
        const Divider(
          thickness: 2,
          height: 0,
        ),
        const Expanded(
          flex: 1,
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
      child: Text(
        question.question,
        key: QuizKeys.questionText('${question.id}'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
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
                      text: 'A) ${question.options[OptionIndex.A]!}',
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
                      text: 'B) ${question.options[OptionIndex.B]!}',
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
                      text: 'C) ${question.options[OptionIndex.C]!}',
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
                      text: 'D) ${question.options[OptionIndex.D]!}',
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
  const _OptionButton(
      {Key? key,
      this.onTap,
      required this.text,
      this.status = _OptionButtonStatus.initial})
      : super(key: key);
  final String text;
  final Function()? onTap;
  final _OptionButtonStatus status;

  Color? get _materialColor {
    switch (status) {
      case _OptionButtonStatus.initial:
        return null;
      case _OptionButtonStatus.selected:
        return Colors.lightBlue[400];
      case _OptionButtonStatus.disabled:
        return Colors.grey[300];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _materialColor,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(text),
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
        return ElevatedButton(
          onPressed:
              canPress ? () => context.read<QuizCubit>().continueQuiz() : null,
          child: const Text('Continue'),
        );
      },
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
