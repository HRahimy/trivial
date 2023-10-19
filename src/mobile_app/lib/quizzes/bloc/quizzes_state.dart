part of 'quizzes_cubit.dart';

class QuizzesState extends Equatable {
  const QuizzesState({
    this.quizzes = const [],
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final List<Quiz> quizzes;
  final FormzSubmissionStatus status;
  final String error;

  QuizzesState copyWith({
    List<Quiz>? quizzes,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return QuizzesState(
      quizzes: quizzes ?? this.quizzes,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [quizzes, status, error];
}
