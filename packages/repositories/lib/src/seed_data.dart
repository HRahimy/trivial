import 'package:repositories/src/models/quiz.dart';
import 'package:repositories/src/models/quiz_question.dart';

class SeedData {
  static const Quiz wowQuiz = Quiz(
    id: 1,
    name: 'World of Warcraft',
  );

  static const Quiz elderScrollsQuiz = Quiz(
    id: 2,
    name: 'Elder Scrolls',
  );

  static const List<Quiz> quizzes = [
    wowQuiz,
    elderScrollsQuiz,
  ];

  static const QuizQuestion wowQuestion1 = QuizQuestion(
    id: 1,
    quizId: 1,
    sequenceIndex: 1,
    points: 10,
    question: 'Who was the High Chieftain of the Tauren before Baine Bloodhoof',
    options: {
      OptionIndex.A: 'Cairne Bloodhoof',
      OptionIndex.B: 'Varok Saurfang',
      OptionIndex.C: 'Tamalaa Bloodhoof',
      OptionIndex.D: 'Elder Bloodhoof',
    },
    correctOption: OptionIndex.A,
  );

  static const QuizQuestion wowQuestion2 = QuizQuestion(
    id: 2,
    quizId: 1,
    sequenceIndex: 2,
    points: 15,
    question: 'Which of these creatures are native to Elwynn Forest?',
    options: {
      OptionIndex.A: 'Quillboar',
      OptionIndex.B: 'Murlocs',
      OptionIndex.C: 'Tauren',
      OptionIndex.D: 'Dreadlords',
    },
    correctOption: OptionIndex.B,
  );

  static const QuizQuestion wowQuestion3 = QuizQuestion(
    id: 3,
    quizId: 1,
    sequenceIndex: 3,
    points: 20,
    question: 'What is the title of Stormwind\'s ruling monarch?',
    options: {
      OptionIndex.A: 'High Priest',
      OptionIndex.B: 'Prophet',
      OptionIndex.C: 'King',
      OptionIndex.D: 'Overlord',
    },
    correctOption: OptionIndex.C,
  );

  static const List<QuizQuestion> wowQuestions = [
    wowQuestion1,
    wowQuestion2,
    wowQuestion3,
  ];
}
