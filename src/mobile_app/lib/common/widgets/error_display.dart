import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivial/common/common_keys.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(
      key: CommonKeys.errorCopySnackbar,
      content: Text(
        'Copied to clipboard',
        key: CommonKeys.errorCopySnackbarText,
      ),
    );

    return Scaffold(
      key: CommonKeys.errorDisplay,
      appBar: AppBar(
        title: const Text(
          'Error detected',
          key: CommonKeys.errorAppBarTitle,
        ),
        leading: const Icon(
          Icons.error_rounded,
          key: CommonKeys.errorIcon,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            key: CommonKeys.errorCopyButton,
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: content),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text(
              'Copy Error',
              key: CommonKeys.errorCopyButtonText,
            ),
          ),
          const Divider(
            thickness: 2,
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Text(
                content,
                key: CommonKeys.errorContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
