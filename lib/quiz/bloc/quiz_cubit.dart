import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trivial/common/models/quiz.dart';
import 'package:trivial/common/models/quiz_question.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required Quiz quiz,
    required List<QuizQuestion> quizQuestions,
  }) : _quiz = quiz, _quizQuestions = quizQuestions, super(const QuizState());

  final Quiz _quiz;
  final List<QuizQuestion> _quizQuestions;
}
