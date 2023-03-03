import 'package:flutter/widgets.dart';
import 'package:trivial/quizzes/widgets/quiz_list_screen.dart';

Map<String, Widget Function(BuildContext context)> namedRoutes(
    BuildContext context) {
  return {
    QuizListScreen.routeName: (context) => const QuizListScreen(),
  };
}
