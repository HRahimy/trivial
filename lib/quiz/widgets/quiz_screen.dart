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
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress ||
              state.status == FormzSubmissionStatus.initial) {
            return const CircularProgressIndicator();
          } else if (state.status == FormzSubmissionStatus.failure) {
            return Text(state.error);
          } else {
            return _Layout(question: state.currentQuestion);
          }
        },
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({
    Key? key,
    required this.question,
  }) : super(key: key);

  final QuizQuestion question;

  Widget optionsGrid() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () => {},
                    child: Center(
                      child: Text(
                        'A) ${question.options[OptionIndex.A]!}',
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(
                thickness: 2,
                width: 1,
              ),
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () => {},
                    child: Center(
                      child: Text(
                        'B) ${question.options[OptionIndex.B]!}',
                      ),
                    ),
                  ),
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
                child: Material(
                  child: InkWell(
                    onTap: () => {},
                    child: Center(
                      child: Text(
                        'C) ${question.options[OptionIndex.C]!}',
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(
                thickness: 2,
                width: 1,
              ),
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () => {},
                    child: Center(
                      child: Text(
                        'D) ${question.options[OptionIndex.D]!}',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 5,
          height: 0,
        ),
        Expanded(
          child: optionsGrid(),
        ),
      ],
    );
  }
}
