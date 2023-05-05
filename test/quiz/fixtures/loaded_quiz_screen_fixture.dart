import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/named_routes.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';
import 'package:trivial/quiz/widgets/quiz_screen.dart';

import '../../mocks/quiz_cubit_mock.dart';
import '../../tests_navigator_observer.dart';

class LoadedQuizScreenFixture extends StatelessWidget {
  LoadedQuizScreenFixture({
    Key? key,
    QuizCubit? quizCubit,
    NavigatorObserver? navigatorObserver,
  })  : _cubit = quizCubit ?? QuizCubitMock(),
        _navigatorObserver = navigatorObserver ?? TestsNavigatorObserver(),
        super(key: key);

  final QuizCubit _cubit;
  final NavigatorObserver _navigatorObserver;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizCubit>.value(
      value: _cubit,
      child: MaterialApp(
        home: const LoadedQuizScreen(),
        routes: namedRoutes(context),
        navigatorObservers: [_navigatorObserver],
      ),
    );
  }
}
