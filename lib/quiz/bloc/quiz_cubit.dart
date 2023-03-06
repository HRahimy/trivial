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
      status: FormzSubmissionStatus.inProgress,
    ));
    try {
      final Quiz quiz = _repository.getQuiz(_quizId);
      final List<QuizQuestion> questions = _repository.getQuestions(_quizId);
      final QuizQuestion firstQuestion =
          questions.firstWhere((e) => e.sequenceIndex == 1);

      emit(state.copyWith(
        quiz: quiz,
        quizQuestions: questions,
        questionIndex: 1,
        currentQuestion: firstQuestion,
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
    QuizState newState = state;
    if (choice == state.currentQuestion.correctOption) {
      newState = newState.copyWith(
        score: state.score + state.currentQuestion.points,
      );
    }
    final int newQuestionIndex = state.questionIndex + 1;
    final newQuestion = state.quizQuestions
        .firstWhere((element) => element.sequenceIndex == newQuestionIndex);
    newState = newState.copyWith(
      questionIndex: newQuestionIndex,
      currentQuestion: newQuestion,
    );
    emit(newState);
  }
}
