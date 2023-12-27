import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/named_routes.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';
import 'package:trivial/quizzes/widgets/quiz_list.dart';

import '../../mocks/quiz_repository_mock.dart';

class QuizListFixture extends StatelessWidget {
  const QuizListFixture({
    Key? key,
    required QuizzesCubit cubit,
    QuizRepository? quizRepository,
    NavigatorObserver? navigatorObserver,
  })  : _cubit = cubit,
        _quizRepository = quizRepository,
        _navigatorObserver = navigatorObserver,
        super(key: key);

  final QuizzesCubit _cubit;
  final QuizRepository? _quizRepository;
  final NavigatorObserver? _navigatorObserver;

  @override
  Widget build(BuildContext context) {
    final repositoryChild = BlocProvider<QuizzesCubit>.value(
      value: _cubit,
      child: MaterialApp(
        home: const QuizList(),
        routes: namedRoutes(context),
        navigatorObservers:
            _navigatorObserver != null ? [_navigatorObserver!] : [],
      ),
    );

    return _quizRepository != null
        ? RepositoryProvider<QuizRepository>.value(
            value: _quizRepository!,
            child: repositoryChild,
          )
        : RepositoryProvider<QuizRepository>(
            create: (_) => MockQuizRepository(),
            child: repositoryChild,
          );
  }
}
