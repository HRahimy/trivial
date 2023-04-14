import 'dart:math' as math;
import 'package:flutter/material.dart';

class TwinkleStar extends StatefulWidget {
  const TwinkleStar({
    Key? key,
    required this.numberOfLines,
    required this.initialRadius,
    required this.strokeWidth,
    required this.evenStrokeLength,
    required this.oddStrokeLength,
    required this.evenStrokeColor,
    required this.oddStrokeColor,
    this.animationDuration = const Duration(milliseconds: 700),
  }) : super(key: key);

  final int numberOfLines;
  final double initialRadius;
  final double strokeWidth;
  final double evenStrokeLength;
  final double oddStrokeLength;
  final Color evenStrokeColor;
  final Color oddStrokeColor;
  final Duration animationDuration;

  @override
  createState() => _TwinkleStarState();
}

class _TwinkleStarState extends State<TwinkleStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _radiusAnimation;
  double _currentRadius = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(() {
        setState(() {
          _currentRadius = _radiusAnimation.value;
        });
      });

    final double maxRadius = math.max(
      widget.evenStrokeLength,
      widget.oddStrokeLength,
    );
    _radiusAnimation = Tween<double>(
      begin: widget.initialRadius,
      end: maxRadius,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: _TwinkleLinesPainter(
            numberOfLines: widget.numberOfLines,
            initialRadius: widget.initialRadius,
            currentRadius: _currentRadius,
            strokeWidth: widget.strokeWidth,
            evenStrokeLength: widget.evenStrokeLength,
            oddStrokeLength: widget.oddStrokeLength,
            evenStrokeColor: widget.evenStrokeColor,
            oddStrokeColor: widget.oddStrokeColor,
          ),
        );
      },
    );
  }
}

class _TwinkleLinesPainter extends CustomPainter {
  _TwinkleLinesPainter({
    required this.numberOfLines,
    required this.initialRadius,
    required this.currentRadius,
    required this.strokeWidth,
    required this.evenStrokeLength,
    required this.oddStrokeLength,
    required this.evenStrokeColor,
    required this.oddStrokeColor,
  });

  final int numberOfLines;
  final double initialRadius;
  final double currentRadius;
  final double strokeWidth;
  final double evenStrokeLength;
  final double oddStrokeLength;
  final Color evenStrokeColor;
  final Color oddStrokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final evenStrokePaint = Paint()
      ..color = evenStrokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final oddStrokePaint = Paint()
      ..color = oddStrokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final hiddenStrokePaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final angleIncrement = 2 * math.pi / numberOfLines;

    for (var i = 0; i < numberOfLines; i++) {
      final angle = i * angleIncrement;
      final initialStartX = centerX + initialRadius * math.cos(angle);
      final initialStartY = centerY + currentRadius * math.sin(angle);
      final startX = centerX + currentRadius * math.cos(angle);
      final startY = centerY + currentRadius * math.sin(angle);
      final endX = centerX +
          (i.isEven ? evenStrokeLength : oddStrokeLength) * math.cos(angle);
      final endY = centerY +
          (i.isEven ? evenStrokeLength : oddStrokeLength) * math.sin(angle);

      final initialStartOffset = Offset(initialStartX, initialStartY);
      final startOffset = Offset(startX, startY);
      final endOffset = Offset(endX, endY);

      final maxDistance = (initialStartOffset - endOffset).distance;
      final startDistanceFromInitial =
          (initialStartOffset - startOffset).distance;
      // Only draw if the current radius is not bigger than the maximum
      // it should be for this stroke.
      if (maxDistance >= startDistanceFromInitial) {
        canvas.drawLine(
          startOffset,
          endOffset,
          startDistanceFromInitial >= maxDistance
              ? hiddenStrokePaint
              : i.isEven
                  ? evenStrokePaint
                  : oddStrokePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TwinkleLinesPainter oldDelegate) => true;
}
