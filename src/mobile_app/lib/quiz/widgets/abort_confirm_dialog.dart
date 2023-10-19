import 'package:flutter/material.dart';
import 'package:trivial/quiz/quiz_keys.dart';

class AbortConfirmDialog extends StatelessWidget {
  const AbortConfirmDialog({
    Key? key,
    this.onAccept,
  }) : super(key: key);
  final Function()? onAccept;

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
          onPressed: onAccept,
          child: const Text(
            'Yep',
            key: QuizKeys.abortDialogAcceptButtonText,
          ),
        ),
      ],
    );
  }
}
