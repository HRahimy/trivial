import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
    // return Card(
    //   child: ,
    // )
  }
}
