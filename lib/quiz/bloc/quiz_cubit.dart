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
    if (state.complete) {
      emit(const QuizState());
    }
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
    if (state.questionDepleted ||
        state.status != FormzSubmissionStatus.success) {
      return;
    }

    emit(state.copyWith(
      selectedOption: choice,
      choiceSelected: true,
    ));
  }

  void continueQuiz() {
    if (state.complete) {
      return;
    }

    if (!state.questionDepleted && !state.choiceSelected) {
      return;
    }

    QuizState newState = state;
    if (state.selectedOption == state.currentQuestion.correctOption) {
      newState = newState.copyWith(
        score: state.score + state.currentQuestion.points,
      );
    }

    if (!state.quizQuestions
        .any((element) => element.sequenceIndex > state.questionIndex)) {
      emit(newState.copyWith(
        complete: true,
        choiceSelected: false,
        questionDepleted: false,
      ));
      return;
    }

    newState = newState.copyWith(
      questionIndex: state.questionIndex + 1,
      choiceSelected: false,
      questionDepleted: false,
    );

    emit(newState);
  }

  void depleteQuestion() {
    if (state.questionDepleted) {
      return;
    }

    emit(state.copyWith(
      questionDepleted: true,
    ));
  }
}
