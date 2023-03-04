import 'package:flutter/material.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/app.dart';

void main() {
  final QuizRepository quizRepository = QuizRepository();
  runApp(App(
    quizRepository: quizRepository,
  ));
}
