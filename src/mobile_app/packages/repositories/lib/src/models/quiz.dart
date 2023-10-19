import 'package:equatable/equatable.dart';

enum QuizDifficulty { easy, normal, hard }

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.name,
    this.description = '',
    this.difficulty = QuizDifficulty.normal,
  });

  final int id;
  final String name;
  final String description;
  final QuizDifficulty difficulty;

  static const Quiz empty = Quiz(
    id: 0,
    name: '-empty-',
    description: '-empty-',
    difficulty: QuizDifficulty.easy,
  );

  @override
  List<Object> get props => [id, name, description, difficulty];
}
