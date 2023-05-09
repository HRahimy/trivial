part of 'quiz_cubit.dart';

enum QuizStatus { initial, started, complete }

enum AnswerStatus { initial, selected, confirmed, depleted }

class QuizState extends Equatable {
  const QuizState({
    this.quiz = Quiz.empty,
    this.quizQuestions = const [],
    this.answers = const {},
    this.score = 0,
    this.questionIndex = 0,
    this.choiceSelected = false,
    this.questionDepleted = false,
    this.answerStatus = AnswerStatus.initial,
    OptionIndex? selectedOption = OptionIndex.A,
    this.status = QuizStatus.initial,
    this.loadingStatus = FormzSubmissionStatus.initial,
    this.error = '',
  }) : _selectedOption = selectedOption ?? OptionIndex.A;

  final Quiz quiz;
  final List<QuizQuestion> quizQuestions;
  final Map<int, OptionIndex> answers;
  final int score;
  final int questionIndex;
  final bool choiceSelected;
  final bool questionDepleted;
  final AnswerStatus answerStatus;
  final OptionIndex _selectedOption;
  final QuizStatus status;
  final FormzSubmissionStatus loadingStatus;
  final String error;

  QuizQuestion get currentQuestion {
    return quizQuestions
        .firstWhere((element) => element.sequenceIndex == questionIndex);
  }

  OptionIndex? get selectedOption {
    return answerStatus == AnswerStatus.selected ||
            answerStatus == AnswerStatus.confirmed
        ? _selectedOption
        : null;
  }

  QuizState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? quizQuestions,
    Map<int, OptionIndex>? answers,
    int? score,
    int? questionIndex,
    bool? choiceSelected,
    bool? questionDepleted,
    AnswerStatus? answerStatus,
    OptionIndex? selectedOption,
    QuizStatus? status,
    FormzSubmissionStatus? loadingStatus,
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
      answerStatus: answerStatus ?? this.answerStatus,
      selectedOption: selectedOption ?? _selectedOption,
      status: status ?? this.status,
      loadingStatus: loadingStatus ?? this.loadingStatus,
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
        answerStatus,
        _selectedOption,
        status,
        loadingStatus,
        error,
      ];
}
