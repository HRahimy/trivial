import 'package:repositories/repositories.dart';

class QuizRepository {
  Quiz getQuiz(int id) {
    return SeedData.quizzes.firstWhere((element) => element.id == id);
  }

  List<Quiz> getQuizzes() {
    return SeedData.quizzes;
  }

  List<QuizQuestion> getQuestions(int quizId) {
    return SeedData.allQuestions
        .where((element) => element.quizId == quizId)
        .toList();
  }
}
