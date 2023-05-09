import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      loadingStatus: FormzSubmissionStatus.inProgress,
    ));
    try {
      final Quiz quiz = _repository.getQuiz(_quizId);
      final List<QuizQuestion> questions = _repository.getQuestions(_quizId);

      emit(state.copyWith(
        quiz: quiz,
        quizQuestions: questions,
        questionIndex: 1,
        loadingStatus: FormzSubmissionStatus.success,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: FormzSubmissionStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void startQuiz() {
    if (state.status == QuizStatus.started ||
        state.status == QuizStatus.complete ||
        state.loadingStatus != FormzSubmissionStatus.success) {
      return;
    }

    emit(state.copyWith(status: QuizStatus.started));
  }

  /// Resets state back to initial and begins loading
  void restartQuiz() {
    if (state.status == QuizStatus.initial) return;

    emit(const QuizState());
    loadQuiz();
  }

  void selectAnswer(OptionIndex choice) {
    if (state.loadingStatus != FormzSubmissionStatus.success) return;

    switch (state.answerStatus) {
      case AnswerStatus.confirmed:
        return;
      case AnswerStatus.depleted:
        return;
      default:
        emit(state.copyWith(
          selectedOption: choice,
          answerStatus: AnswerStatus.selected,
        ));
    }
  }

  void confirmAnswer() {
    switch (state.answerStatus) {
      case AnswerStatus.initial:
        return;
      case AnswerStatus.selected:
        bool optionCorrect =
            state.selectedOption == state.currentQuestion.correctOption;
        if (optionCorrect) {
          emit(state.copyWith(
            answerStatus: AnswerStatus.confirmed,
            score: state.score + state.currentQuestion.points,
          ));
        } else {
          emit(state.copyWith(
            answerStatus: AnswerStatus.confirmed,
          ));
        }
        return;
      case AnswerStatus.confirmed:
        return;
      case AnswerStatus.depleted:
        return;
    }
  }

  void continueQuiz() {
    if (state.status == QuizStatus.complete) return;

    switch (state.answerStatus) {
      case AnswerStatus.initial:
        return;
      case AnswerStatus.selected:
        return;
      default:
        break;
    }

    if (!state.quizQuestions
        .any((element) => element.sequenceIndex > state.questionIndex)) {
      emit(state.copyWith(status: QuizStatus.complete));
      return;
    }

    emit(state.copyWith(
      questionIndex: state.questionIndex + 1,
      answerStatus: AnswerStatus.initial,
    ));
  }

  void terminateTime() {
    switch (state.answerStatus) {
      case AnswerStatus.initial:
        emit(state.copyWith(
          answerStatus: AnswerStatus.depleted,
        ));
        return;
      case AnswerStatus.selected:
        bool optionCorrect =
            state.selectedOption == state.currentQuestion.correctOption;
        if (optionCorrect) {
          emit(state.copyWith(
            answerStatus: AnswerStatus.confirmed,
            score: state.score + state.currentQuestion.points,
          ));
        } else {
          emit(state.copyWith(
            answerStatus: AnswerStatus.confirmed,
          ));
        }
        return;
      case AnswerStatus.confirmed:
        return;
      case AnswerStatus.depleted:
        return;
    }
  }
}
