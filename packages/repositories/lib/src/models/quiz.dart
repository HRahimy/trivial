import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static const Quiz empty = Quiz(
    id: 0,
    name: '-empty-',
  );

  @override
  List<Object> get props => [id, name];
}
