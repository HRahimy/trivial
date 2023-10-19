import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trivial/theme.dart';

class TwinkleStarStyle extends Equatable {
  const TwinkleStarStyle({
    this.numberOfLines = 8,
    this.initialRadius = 8,
    this.strokeWidth = 2,
    this.evenStrokeLength = 20,
    this.oddStrokeLength = 17,
    this.evenStrokeColor = AppTheme.primaryColor,
    this.oddStrokeColor = AppTheme.complementaryColor,
    this.animationDuration = 700,
  })  : assert(evenStrokeLength > oddStrokeLength),
        assert(evenStrokeLength > 0),
        assert(oddStrokeLength > 0),
        assert(numberOfLines % 2 == 0),
        assert(initialRadius > 0),
        assert(animationDuration > 100);

  final int numberOfLines;
  final double initialRadius;
  final double strokeWidth;
  final double evenStrokeLength;
  final double oddStrokeLength;
  final Color evenStrokeColor;
  final Color oddStrokeColor;

  /// In milliseconds
  final int animationDuration;

  @override
  List<Object> get props => [
        numberOfLines,
        initialRadius,
        strokeWidth,
        evenStrokeLength,
        oddStrokeLength,
        evenStrokeColor,
        oddStrokeColor,
      ];
}

class TwinkleStar extends StatefulWidget {
  const TwinkleStar({
    Key? key,
    this.style = const TwinkleStarStyle(),
    this.onComplete,
  }) : super(key: key);

  final TwinkleStarStyle style;
  final Function()? onComplete;

  double get boxDimensions {
    return 2 *
        (style.initialRadius +
            math.max(style.evenStrokeLength, style.oddStrokeLength));
  }

  @override
  createState() => _TwinkleStarState();
}

class _TwinkleStarState extends State<TwinkleStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _radiusAnimation;
  double _currentRadius = 0;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.style.animationDuration),
    )..addListener(() {
        setState(() {
          _currentRadius = _radiusAnimation.value;
        });

        if (!_animationComplete && _animationController.isCompleted) {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
          _animationComplete = true;
        }
      });

    final double maxRadius = math.max(
      widget.style.evenStrokeLength,
      widget.style.oddStrokeLength,
    );
    _radiusAnimation = Tween<double>(
      begin: widget.style.initialRadius,
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
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: widget.boxDimensions,
        width: widget.boxDimensions,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: _TwinkleLinesPainter(
                numberOfLines: widget.style.numberOfLines,
                initialRadius: widget.style.initialRadius,
                currentRadius: _currentRadius,
                strokeWidth: widget.style.strokeWidth,
                evenStrokeLength: widget.style.evenStrokeLength,
                oddStrokeLength: widget.style.oddStrokeLength,
                evenStrokeColor: widget.style.evenStrokeColor,
                oddStrokeColor: widget.style.oddStrokeColor,
              ),
            );
          },
        ),
      ),
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
