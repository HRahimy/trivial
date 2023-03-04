import 'package:equatable/equatable.dart';

enum OptionIndex { A, B, C, D }

class QuizQuestion extends Equatable {
  const QuizQuestion({
    this.id = 0,
    this.quizId = 0,
    this.sequenceIndex = 0,
    this.question = '',
    this.options = const {},
    this.correctOption = OptionIndex.A,
    this.points = 0,
  });

  final int id;
  final int quizId;
  final int sequenceIndex;
  final String question;
  final Map<OptionIndex, String> options;
  final OptionIndex correctOption;
  final int points;

  static const QuizQuestion empty = QuizQuestion(
    id: 0,
    quizId: 0,
    sequenceIndex: 0,
    question: '-empty-',
    options: {},
    correctOption: OptionIndex.A,
    points: 0,
  );

  @override
  List<Object> get props => [
        id,
        quizId,
        sequenceIndex,
        question,
        options,
        correctOption,
        points,
      ];
}
