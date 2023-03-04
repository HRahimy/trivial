import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.name,
    required this.durationInSeconds,
  });

  final int id;
  final String name;
  final int durationInSeconds;

  static const Quiz empty = Quiz(
    id: 0,
    name: '-empty-',
    durationInSeconds: 0,
  );

  @override
  List<Object> get props => [id, name, durationInSeconds];
}
