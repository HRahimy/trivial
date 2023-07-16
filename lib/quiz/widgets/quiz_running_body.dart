import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/quiz_keys.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';
import 'package:trivial/theme.dart';

class QuizRunningBody extends StatelessWidget {
  const QuizRunningBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Reference to fix for FAB highlight color change:
      // https://stackoverflow.com/a/54613679/5472560
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(highlightColor: Colors.transparent),
        child: FloatingActionButton.extended(
          key: QuizKeys.abortButton,
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (childContext) => AbortConfirmDialog(
              key: QuizKeys.abortDialog,
              onAccept: () {
                Navigator.pop(childContext);
                context.read<QuizCubit>().restartQuiz();
              },
            ),
          ),
          elevation: 2,
          disabledElevation: 2,
          focusElevation: 2,
          highlightElevation: 2,
          backgroundColor: Theme.of(context).cardColor,
          label: const Text(
            'Abort',
            key: QuizKeys.abortButtonText,
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.red,
            key: QuizKeys.abortButtonIcon,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const _Layout(),
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
        const _ContinueControls(),
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
      context.read<QuizCubit>().terminateTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listenWhen: (previous, current) =>
          previous.answerStatus != current.answerStatus,
      listener: (context, state) {
        if (state.answerStatus == AnswerStatus.confirmed) {
          controller?.stop();
        }
      },
      child: AnimatedBuilder(
        animation: controller!,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: controller!.value,
            minHeight: 16,
            backgroundColor: AppTheme().primarySwatch.withOpacity(0.3),
          );
        },
      ),
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
          previous.answerStatus != current.answerStatus,
      builder: (context, state) {
        final question = state.currentQuestion;
        final bool canTap = state.answerStatus != AnswerStatus.confirmed &&
            state.answerStatus != AnswerStatus.depleted;
        final bool questionClosed =
            state.answerStatus == AnswerStatus.depleted ||
                state.answerStatus == AnswerStatus.confirmed;
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
                      onTap: canTap
                          ? () => cubit.selectAnswer(OptionIndex.A)
                          : null,
                      status: state.selectedOption == OptionIndex.A
                          ? _OptionButtonStatus.selected
                          : questionClosed
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
                      onTap: canTap
                          ? () => cubit.selectAnswer(OptionIndex.B)
                          : null,
                      status: state.selectedOption == OptionIndex.B
                          ? _OptionButtonStatus.selected
                          : questionClosed
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
                      onTap: canTap
                          ? () => cubit.selectAnswer(OptionIndex.C)
                          : null,
                      status: state.selectedOption == OptionIndex.C
                          ? _OptionButtonStatus.selected
                          : questionClosed
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
                      onTap: canTap
                          ? () => cubit.selectAnswer(OptionIndex.D)
                          : null,
                      status: state.selectedOption == OptionIndex.D
                          ? _OptionButtonStatus.selected
                          : questionClosed
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

class _ContinueControls extends StatelessWidget {
  const _ContinueControls();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (previous, current) =>
          previous.answerStatus != current.answerStatus,
      builder: (context, state) {
        final questionId = '${state.currentQuestion.id}';
        final continueButton = IconButton(
          key: QuizKeys.continueActionButton(questionId),
          onPressed: () => context.read<QuizCubit>().continueQuiz(),
          iconSize: 40,
          color: Colors.black,
          highlightColor: Colors.white,
          icon: Icon(
            Icons.arrow_right_rounded,
            key: QuizKeys.continueActionButtonIcon(questionId),
          ),
        );
        switch (state.answerStatus) {
          case AnswerStatus.initial:
            return ListTile(
              tileColor: AppTheme().analogousLowerSwatch[300],
              title: Text(
                'Select an answer!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                key: QuizKeys.selectMessage(questionId),
              ),
            );
          case AnswerStatus.selected:
            return ListTile(
              key: QuizKeys.confirmTile(questionId),
              tileColor: AppTheme().analogousLowerSwatch[300],
              title: Text(
                'Are you sure?',
                style: const TextStyle(fontWeight: FontWeight.bold),
                key: QuizKeys.confirmTileTitle(questionId),
              ),
              trailing: IconButton(
                key: QuizKeys.confirmTileActionButton(questionId),
                onPressed: () => context.read<QuizCubit>().confirmAnswer(),
                iconSize: 30,
                color: Colors.black,
                highlightColor: Colors.white,
                icon: Icon(
                  Icons.check_rounded,
                  key: QuizKeys.confirmTileActionButtonIcon(questionId),
                ),
              ),
            );
          case AnswerStatus.confirmed:
            final bool answerCorrect =
                state.currentQuestion.correctOption == state.selectedOption;
            return answerCorrect
                ? ListTile(
                    key: QuizKeys.continueTile(questionId),
                    tileColor: AppTheme().triadicLowerSwatch[100],
                    title: Text(
                      'Correct!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      key: QuizKeys.continueTileCorrectTitle(questionId),
                    ),
                    subtitle: Text(
                      'You earned ${state.currentQuestion.points} levels',
                      key: QuizKeys.continueTileCorrectScore(questionId),
                    ),
                    trailing: continueButton,
                  )
                : ListTile(
                    key: QuizKeys.continueTile(questionId),
                    tileColor: AppTheme().analogousUpperSwatch[200],
                    title: Text(
                      'Incorrect!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      key: QuizKeys.continueTileIncorrectTitle(questionId),
                    ),
                    subtitle: Text(
                      'Better luck next time',
                      key: QuizKeys.continueTileIncorrectMessage(questionId),
                    ),
                    trailing: continueButton,
                  );
          case AnswerStatus.depleted:
            return ListTile(
              key: QuizKeys.continueDepletedTile(questionId),
              tileColor: AppTheme().analogousUpperSwatch[300],
              title: Text(
                'Out of time!',
                style: const TextStyle(fontWeight: FontWeight.bold),
                key: QuizKeys.continueDepletedTileTitle(questionId),
              ),
              trailing: continueButton,
            );
        }
      },
    );
  }
}
