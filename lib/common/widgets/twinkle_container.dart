import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivial/common/widgets/twinkle_star.dart';

/// Randomly spawns [TwinkleStar] widgets in containing area
class TwinkleContainer extends StatefulWidget {
  const TwinkleContainer({
    Key? key,
    this.starStyle,
    this.spawnAreaHeight,
    this.spawnAreaWidth,
    this.verticalAreaInset = 0,
    this.horizontalAreaInset = 0,
    required this.child,
    this.twinkleWaitDuration = 300,
  }) : super(key: key);

  final Widget child;

  /// Time in ms to wait before spawning a new twinkle
  final int twinkleWaitDuration;

  /// Spawned twinkles will use given [starStyle]
  final TwinkleStarStyle? starStyle;

  /// An optional [spawnAreaHeight] will set the height of the area
  /// within which twinkles can spawn.
  /// - Half the current height of the screen will be used by default.
  final double? spawnAreaHeight;

  /// An optional [spawnAreaWidth] will set the width of the area
  /// within which twinkles can spawn.
  /// - The current width of the screen will be used by default.
  final double? spawnAreaWidth;

  /// Reduces the area within which twinkles can spawn from the top
  /// and bottom by the given [verticalAreaInset]
  final double verticalAreaInset;

  /// Reduces the area within which twinkles can spawn from the left
  /// and right by the given [horizontalAreaInset]
  final double horizontalAreaInset;

  @override
  State<StatefulWidget> createState() => _TwinkleContainerState();
}

class _TwinkleContainerState extends State<TwinkleContainer> {
  List<int> _twinkleIds = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _twinkleIds = [_twinkleIds.length + 1];
  }

  void endTwinkle(int id) {
    setState(() {
      List<int> intermediateIds = [..._twinkleIds];
      intermediateIds.remove(id);
      _twinkleIds = intermediateIds;

      _timer = Timer(
        Duration(milliseconds: widget.twinkleWaitDuration),
        () => startTwinkle(id + 1),
      );
    });
  }

  void startTwinkle(int id) {
    setState(() {
      _twinkleIds = [..._twinkleIds, id];
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spawnAreaHeight =
        widget.spawnAreaHeight ?? (MediaQuery.of(context).size.height / 2);
    final spawnAreaWidth =
        widget.spawnAreaWidth ?? MediaQuery.of(context).size.width;

    return Stack(
      children: [
        ..._twinkleIds.map((e) {
          final star = TwinkleStar(
            key: Key('${widget.key.toString()}__twinkleStar_$e'),
            onComplete: () => endTwinkle(e),
            style: widget.starStyle ?? const TwinkleStarStyle(),
          );

          // Get max and min values for height and width
          final minHeight = star.boxDimensions + widget.verticalAreaInset;
          final maxHeight =
              spawnAreaHeight - (star.boxDimensions + widget.verticalAreaInset);
          final minWidth = star.boxDimensions + widget.horizontalAreaInset;
          final maxWidth = spawnAreaWidth -
              (star.boxDimensions + widget.horizontalAreaInset);

          // Get random top and left values within area
          final rTop = minHeight +
              Random().nextInt((maxHeight - minHeight).toInt()).toDouble();
          final rLeft = minWidth +
              Random().nextInt((maxWidth - minWidth).toInt()).toDouble();

          return Positioned(
            top: rTop,
            left: rLeft,
            child: star,
          );
        }).toList(),
        widget.child,
      ],
    );
  }
}
