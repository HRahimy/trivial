import 'package:flutter/material.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final QuizRepository quizRepository = QuizRepository();
  runApp(App(
    quizRepository: quizRepository,
  ));
}
