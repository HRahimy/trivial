import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required Quiz quiz,
    required List<QuizQuestion> quizQuestions,
  })  : _quiz = quiz,
        _quizQuestions = quizQuestions,
        super(const QuizState());

  /*
  Keeping quiz and questions parameters here because their values originate from an external data source.
  The app's functionality also will not affect these objects, they are simply read from the data source.
  Furthermore, this implementation forces these required parameters to be available for all further functions.
  */
  final Quiz _quiz;
  final List<QuizQuestion> _quizQuestions;
}
