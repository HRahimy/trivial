part of 'quiz_cubit.dart';

enum QuestionStatus { waiting, depleted, choiceSelected, answered }

class QuizState extends Equatable {
  const QuizState({
    this.quiz = Quiz.empty,
    this.quizQuestions = const [],
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
    this.questionStatus = QuestionStatus.waiting,
    OptionIndex? selectedOption = OptionIndex.A,
    this.complete = false,
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  }) : _selectedOption = selectedOption ?? OptionIndex.A;

  final Quiz quiz;
  final List<QuizQuestion> quizQuestions;
  final Map<int, OptionIndex> answers;
  final int score;
  final int questionIndex;
  final QuestionStatus questionStatus;
  final OptionIndex _selectedOption;
  final bool complete;
  final FormzSubmissionStatus status;
  final String error;

  QuizQuestion get currentQuestion {
    return quizQuestions
        .firstWhere((element) => element.sequenceIndex == questionIndex);
  }

  OptionIndex? get selectedOption {
    return questionStatus == QuestionStatus.choiceSelected
        ? _selectedOption
        : null;
  }

  QuizState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? quizQuestions,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
    QuestionStatus? questionStatus,
    OptionIndex? selectedOption,
    bool? complete,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      quizQuestions: quizQuestions ?? this.quizQuestions,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      questionIndex: questionIndex ?? this.questionIndex,
      questionStatus: questionStatus ?? this.questionStatus,
      selectedOption: selectedOption ?? _selectedOption,
      complete: complete ?? this.complete,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        quiz,
        quizQuestions,
        answers,
        score,
        questionIndex,
        questionStatus,
        _selectedOption,
        complete,
        status,
        error,
      ];
}
