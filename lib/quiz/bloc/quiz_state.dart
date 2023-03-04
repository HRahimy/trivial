part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  const QuizState({
    this.quiz = Quiz.empty,
    this.questions = const [],
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
  });

  final Quiz quiz;
  final List<QuizQuestion> questions;
  final Map<int, OptionIndex> answers;
  final int score;
  final int questionIndex;

  QuizState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? questions,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      questionIndex: questionIndex ?? this.questionIndex,
    );
  }

  @override
  List<Object> get props => [quiz, questions, answers, score, questionIndex];
}
