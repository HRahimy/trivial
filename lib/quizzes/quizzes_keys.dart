import 'package:flutter/widgets.dart';

class QuizzesKeys {
  static const Key quizList = Key('__quizList__');

  static Function(String) get quizItemButton =>
      (String id) => Key('__quizItemButton_$id');

  static Function(String) get quizItemButtonText =>
      (String id) => Key('__quizItemButtonText_$id');
}
