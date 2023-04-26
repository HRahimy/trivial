import 'package:flutter/material.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';

import '../../tests_navigator_observer.dart';

class AbortConfirmDialogFixture extends StatelessWidget {
  AbortConfirmDialogFixture({
    Key? key,
    NavigatorObserver? navigatorObserver,
  })  : _navigatorObserver = navigatorObserver ?? TestsNavigatorObserver(),
        super(key: key);

  final NavigatorObserver _navigatorObserver;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [_navigatorObserver],
      home: const Scaffold(
        body: AbortConfirmDialog(),
      ),
    );
  }
}
