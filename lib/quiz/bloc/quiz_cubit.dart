import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required int quizId,
    required QuizRepository quizRepository,
  })  : _quizId = quizId,
        _repository = quizRepository,
        super(const QuizState());

  final int _quizId;
  final QuizRepository _repository;

  void loadQuiz() {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
    ));
    try {
      final Quiz quiz = _repository.getQuiz(_quizId);
      final List<QuizQuestion> questions = _repository.getQuestions(_quizId);

      emit(state.copyWith(
        quiz: quiz,
        quizQuestions: questions,
        questionIndex: 1,
        status: FormzSubmissionStatus.success,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void selectAnswer(OptionIndex choice) {
    if (state.complete) {
      return;
    }

    final int newQuestionIndex = state.questionIndex + 1;
    QuizState newState = state;
    if (choice == state.currentQuestion.correctOption) {
      newState = newState.copyWith(
        score: state.score + state.currentQuestion.points,
      );
    }

    if (!state.quizQuestions
        .any((element) => element.sequenceIndex > state.questionIndex)) {
      emit(newState.copyWith(complete: true));
      return;
    }

    final newQuestion = state.quizQuestions
        .firstWhere((element) => element.sequenceIndex == newQuestionIndex);

    newState = newState.copyWith(
      questionIndex: newQuestionIndex,
    );

    emit(newState);
  }
}
