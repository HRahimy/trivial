import 'package:flutter/foundation.dart';

class CommonKeys {
  //region Twinkle container
  static const Key twinkleStar = Key('__twinkleStar__');
  static const Key twinkleContainer = Key('__twinkleContainer__');
  static const Key twinkleContainerSpawnArea =
      Key('__twinkleContainer_spawnArea__');

  static Function(String) get twinkleContainerStar =>
      (String id) => Key('${twinkleContainer.toString()}twinkleStar_${id}__');

  //endregion

  //region Error display
  static const Key errorDisplay = Key('__errorDisplay__');
  static const Key errorAppBarTitle = Key('__errorAppBarTitle__');
  static const Key errorIcon = Key('__errorIcon__');
  static const Key errorContent = Key('__errorContent__');
  static const Key errorCopyButton = Key('__errorCopyButton__');
  static const Key errorCopyButtonText = Key('__errorCopyButtonText__');
  static const Key errorCopySnackbar = Key('__errorCopySnackbar__');
  static const Key errorCopySnackbarText = Key('__errorCopySnackbarText__');
//endregion
}
