import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivial/common/widgets/twinkle_star.dart';

class TwinkleContainer extends StatefulWidget {
  const TwinkleContainer({
    Key? key,
    this.starStyle,
    this.height,
    this.width,
  }) : super(key: key);

  final TwinkleStarStyle? starStyle;
  final double? height;
  final double? width;

  @override
  State<StatefulWidget> createState() => _TwinkleContainerState();
}

class _TwinkleContainerState extends State<TwinkleContainer> {
  late List<int> _twinkleIds;

  @override
  void initState() {
    super.initState();
    _twinkleIds = [_twinkleIds.length + 1];
  }

  void incrementTwinkle(int id) {
    setState(() {
      List<int> intermediateIds = [..._twinkleIds];
      intermediateIds.remove(id);
      intermediateIds.add(id + 1);
      _twinkleIds = intermediateIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = widget.height ?? MediaQuery.of(context).size.width;
    double containerHeight = widget.width ?? MediaQuery.of(context).size.height;
    double height = containerHeight / 2;
    return SizedBox(
      width: containerWidth,
      height: height,
      child: Stack(
        children: _twinkleIds.map((e) {
          final star = TwinkleStar(
            key: Key('${widget.key.toString()}__twinkleStar_$e'),
            onComplete: () => incrementTwinkle(e),
            style: widget.starStyle ?? const TwinkleStarStyle(),
          );
          final minHeight = star.boxDimensions;
          final maxHeight = height - star.boxDimensions;
          final minWidth = star.boxDimensions;
          final maxWidth = containerWidth - star.boxDimensions;
          return Positioned(
            bottom:
                Random().nextInt((maxHeight - minHeight).toInt()).toDouble(),
            right: Random().nextInt((maxWidth - minWidth).toInt()).toDouble(),
            child: star,
          );
        }).toList(),
      ),
    );
  }
}
