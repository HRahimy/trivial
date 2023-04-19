import 'package:flutter/foundation.dart';

class CommonKeys {
  static const Key twinkleStar = Key('__twinkleStar__');
  static const Key twinkleContainer = Key('__twinkleContainer__');
  static const Key twinkleContainerSpawnArea =
      Key('__twinkleContainer_spawnArea__');

  static Function(String) get twinkleContainerStar =>
      (String id) => Key('${twinkleContainer.toString()}twinkleStar_${id}__');
}
