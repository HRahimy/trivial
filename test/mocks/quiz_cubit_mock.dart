import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

class FakeQuizState extends Fake implements QuizState {}

class QuizCubitMock extends MockCubit<QuizState> implements QuizCubit {}
