import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';

part 'quizzes_state.dart';

class QuizzesCubit extends Cubit<QuizzesState> {
  QuizzesCubit({required QuizRepository quizRepository})
      : _repository = quizRepository,
        super(const QuizzesState());

  final QuizRepository _repository;

  void loadInitial() {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
    ));

    try {
      final List<Quiz> quizzes = _repository.getQuizzes();

      emit(state.copyWith(
        quizzes: quizzes,
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
}
