import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/named_routes.dart';
import 'package:trivial/quizzes/widgets/quiz_list_screen.dart';
import 'package:trivial/theme.dart';

class App extends StatelessWidget {
  const App({
    required QuizRepository quizRepository,
    Key? key,
  })  : _quizRepository = quizRepository,
        super(key: key);
  final QuizRepository _quizRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuizRepository>.value(value: _quizRepository),
      ],
      child: MaterialApp(
        title: 'Trivial',
        theme: AppTheme().build(),
        initialRoute: QuizListScreen.routeName,
        routes: namedRoutes(context),
      ),
    );
  }
}
