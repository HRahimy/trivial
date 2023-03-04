import 'package:repositories/repositories.dart';

class QuizRepository {
  Quiz getQuiz(int id) {
    return SeedData.wowQuiz;
  }

  List<Quiz> getQuizzes() {
    return SeedData.quizzes;
  }

  List<QuizQuestion> getQuestions(int quizId) {
    return SeedData.wowQuestions;
  }
}
