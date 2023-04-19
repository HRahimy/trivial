import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivial/common/common_keys.dart';
import 'package:trivial/common/widgets/twinkle_star.dart';

/// Randomly spawns [TwinkleStar] widgets in defined spawn area
class TwinkleContainer extends StatefulWidget {
  const TwinkleContainer({
    Key key = CommonKeys.twinkleContainer,
    this.starStyle = const TwinkleStarStyle(),
    this.spawnAreaPadding = const EdgeInsets.symmetric(),
    this.spawnAreaAlignment = const Alignment(-1, -1),
    this.spawnAreaHeight,
    this.spawnAreaWidth,
    required this.child,
    this.twinkleWaitDuration = 300,
  }) : super(key: key);

  final Widget child;

  /// Time in ms to wait before spawning a new twinkle
  final int twinkleWaitDuration;

  /// Spawned twinkles will use given [starStyle]
  final TwinkleStarStyle starStyle;

  /// An optional [spawnAreaHeight] will set the height of the area
  /// within which twinkles can spawn.
  /// - Half the current height of the screen will be used by default.
  final double? spawnAreaHeight;

  /// An optional [spawnAreaWidth] will set the width of the area
  /// within which twinkles can spawn.
  /// - The current width of the screen will be used by default.
  final double? spawnAreaWidth;

  final EdgeInsets spawnAreaPadding;

  final Alignment spawnAreaAlignment;

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

  Widget buildSpawnArea(BuildContext context) {
    final spawnAreaHeight =
        widget.spawnAreaHeight ?? (MediaQuery.of(context).size.height / 2);
    final spawnAreaWidth =
        widget.spawnAreaWidth ?? MediaQuery.of(context).size.width;

    final containerWidget = Align(
      alignment: widget.spawnAreaAlignment,
      child: SizedBox(
        key: CommonKeys.twinkleContainerSpawnArea,
        height: spawnAreaHeight,
        width: spawnAreaWidth,
        child: Stack(
          children: [
            ..._twinkleIds.map((e) {
              final star = TwinkleStar(
                key: CommonKeys.twinkleContainerStar('$e'),
                onComplete: () => endTwinkle(e),
                style: widget.starStyle,
              );

              // Get max and min values for height and width
              final maxHeight = spawnAreaHeight - star.boxDimensions;
              final maxWidth = spawnAreaWidth - star.boxDimensions;

              // Get random top and left values within area
              final rTop = Random().nextInt(maxHeight.toInt()).toDouble();
              final rLeft = Random().nextInt(maxWidth.toInt()).toDouble();

              return Positioned(
                top: rTop,
                left: rLeft,
                child: star,
              );
            }).toList(),
          ],
        ),
      ),
    );

    return Padding(
      padding: widget.spawnAreaPadding,
      child: containerWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildSpawnArea(context),
        widget.child,
      ],
    );
  }
}
