import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivial/quizzes/bloc/quizzes_cubit.dart';

class FakeQuizzesState extends Fake  implements QuizzesState {}

class QuizzesCubitMock extends MockCubit<QuizzesState> implements QuizzesCubit {
}
