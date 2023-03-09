import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';

class FakeQuizzesState extends Fake implements QuizzesState {}

class QuizzesCubitMock extends MockCubit<QuizzesState> implements QuizzesCubit {
}
