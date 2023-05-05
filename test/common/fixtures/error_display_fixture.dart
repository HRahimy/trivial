import 'package:flutter/material.dart';
import 'package:trivial/common/widgets/error_display.dart';

class ErrorDisplayFixture extends StatelessWidget {
  const ErrorDisplayFixture({
    super.key,
    this.content = '',
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ErrorDisplay(content: content),
    );
  }
}
