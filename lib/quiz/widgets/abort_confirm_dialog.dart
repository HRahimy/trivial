import 'package:flutter/material.dart';
import 'package:trivial/quiz/quiz_keys.dart';

class AbortConfirmDialog extends StatelessWidget {
  const AbortConfirmDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Are you sure?',
        key: QuizKeys.abortDialogTitle,
      ),
      content: const Text(
        'You will lose all progress',
        key: QuizKeys.abortDialogSubtitle,
      ),
      actions: [
        TextButton(
          key: QuizKeys.abortDialogCancelButton,
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            key: QuizKeys.abortDialogCancelButtonText,
          ),
        ),
        TextButton(
          key: QuizKeys.abortDialogAcceptButton,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text(
            'Yep',
            key: QuizKeys.abortDialogAcceptButtonText,
          ),
        ),
      ],
    );
  }
}
