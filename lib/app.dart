import 'package:flutter/material.dart';
import 'package:trivial/named_routes.dart';
import 'package:trivial/quizzes/widgets/quiz_list_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: QuizListScreen.routeName,
      routes: namedRoutes(context),
    );
  }
}
