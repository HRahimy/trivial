part of 'quiz_cubit.dart';

class QuizState extends Equatable {
  const QuizState({
    this.quiz = Quiz.empty,
    this.quizQuestions = const [],
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
    this.choiceSelected = false,
    this.questionDepleted = false,
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
  final bool choiceSelected;
  final bool questionDepleted;
  final OptionIndex _selectedOption;
  final bool complete;
  final FormzSubmissionStatus status;
  final String error;

  QuizQuestion get currentQuestion {
    return quizQuestions
        .firstWhere((element) => element.sequenceIndex == questionIndex);
  }

  OptionIndex? get selectedOption {
    return choiceSelected ? _selectedOption : null;
  }

  QuizState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? quizQuestions,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
    bool? choiceSelected,
    bool? questionDepleted,
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
      choiceSelected: choiceSelected ?? this.choiceSelected,
      questionDepleted: questionDepleted ?? this.questionDepleted,
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
        choiceSelected,
        questionDepleted,
        _selectedOption,
        complete,
        status,
        error,
      ];
}
