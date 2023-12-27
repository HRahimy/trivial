import 'package:flutter/material.dart';
import 'package:trivial/quiz/widgets/abort_confirm_dialog.dart';

import '../../tests_navigator_observer.dart';

class AbortConfirmDialogFixture extends StatelessWidget {
  AbortConfirmDialogFixture({
    Key? key,
    NavigatorObserver? navigatorObserver,
    this.onAccept,
  })  : _navigatorObserver = navigatorObserver ?? TestsNavigatorObserver(),
        super(key: key);

  final NavigatorObserver _navigatorObserver;
  final Function()? onAccept;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [_navigatorObserver],
      home: Scaffold(
        body: AbortConfirmDialog(
          onAccept: onAccept,
        ),
      ),
    );
  }
}
