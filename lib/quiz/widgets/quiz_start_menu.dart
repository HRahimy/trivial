import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivial/quiz/bloc/quiz_cubit.dart';

class QuizStartMenu extends StatelessWidget {
  const QuizStartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizCubit>().state.quiz;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: Text('Text section'),
            ),
            Expanded(
              flex: 1,
              child: _ButtonSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalDirection: VerticalDirection.up,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Back'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Play'),
        ),
      ],
    );
  }
}
