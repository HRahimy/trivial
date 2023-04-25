import 'package:flutter/material.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';

class AbortConfirmDialogFixture extends StatelessWidget {
  const AbortConfirmDialogFixture({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: AbortConfirmDialog(),
      ),
    );
  }
}
