import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:trivial/common/models/quiz.dart';
import 'package:trivial/common/models/quiz_question.dart';
import 'package:trivial/seed_data.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit() : super(const QuizzesState());
}
