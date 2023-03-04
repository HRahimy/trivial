part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  const QuizState({
    this.currentQuestion = QuizQuestion.empty,
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
  });

  final QuizQuestion currentQuestion;
  final Map<int, OptionIndex> answers;
  final int score;
  final int questionIndex;

  QuizState copyWith({
    QuizQuestion? currentQuestion,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
  }) {
    return QuizState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      questionIndex: questionIndex ?? this.questionIndex,
    );
  }

  @override
  List<Object> get props => [currentQuestion, answers, score, questionIndex];
}
