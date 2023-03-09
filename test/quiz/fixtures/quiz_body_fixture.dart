import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:trivial/named_routes.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/widgets/quiz_body.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../mocks/quiz_repository_mock.dart';
import '../../tests_navigator_observer.dart';

class QuizBodyFixture extends StatelessWidget {
  QuizBodyFixture({
    Key? key,
    QuizCubit? quizCubit,
    QuizRepository? quizRepository,
    NavigatorObserver? navigatorObserver,
  })  : _cubit = quizCubit ?? QuizCubitMock(),
        _quizRepository = quizRepository ?? MockQuizRepository(),
        _navigatorObserver = navigatorObserver ?? TestsNavigatorObserver(),
        super(key: key);

  final QuizCubit _cubit;
  final QuizRepository _quizRepository;
  final NavigatorObserver _navigatorObserver;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<QuizRepository>.value(
      value: _quizRepository,
      child: BlocProvider<QuizCubit>.value(
        value: _cubit,
        child: MaterialApp(
          home: const QuizBody(),
          routes: namedRoutes(context),
          navigatorObservers: [_navigatorObserver],
        ),
      ),
    );
  }
}
