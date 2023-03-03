import 'package:equatable/equatable.dart';

enum CorrectOption { A, B, C, D }

class QuizQuestion extends Equatable {
  const QuizQuestion({
    this.id = 0,
    this.quizId = 0,
    this.sequenceIndex = 0,
    this.question = '',
    this.optionA = 'A',
    this.optionB = 'B',
    this.optionC = 'C',
    this.optionD = 'D',
    this.correctOption = CorrectOption.A,
    this.points = 0,
  });

  final int id;
  final int quizId;
  final int sequenceIndex;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final CorrectOption correctOption;
  final int points;

  @override
  List<Object> get props => [
        id,
        quizId,
        sequenceIndex,
        question,
        optionA,
        optionB,
        optionC,
        optionD,
        correctOption,
        points,
      ];
}
