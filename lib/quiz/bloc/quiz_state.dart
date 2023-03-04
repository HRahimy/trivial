part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  const QuizState({
    this.quiz = Quiz.empty,
    this.quizQuestions = const [],
    this.currentQuestion = QuizQuestion.empty,
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final Quiz quiz;
  final List<QuizQuestion> quizQuestions;
  final QuizQuestion currentQuestion;
  final Map<int, OptionIndex> answers;
  final int score;
  final int questionIndex;
  final FormzSubmissionStatus status;
  final String error;

  QuizState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? quizQuestions,
    QuizQuestion? currentQuestion,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      questionIndex: questionIndex ?? this.questionIndex,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        quiz,
        quizQuestions,
        currentQuestion,
        answers,
        score,
        questionIndex,
        status,
        error,
      ];
}
