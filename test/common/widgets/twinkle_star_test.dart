import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/common/widgets/twinkle_star.dart';

void main() {
  testWidgets('TwinkleStar widget has correct size',
      (WidgetTester tester) async {
    final double initialRadius = 8.0;
    final double evenStrokeLength = 150.0;
    final double oddStrokeLength = 100.0;
    final twinkleStar = TwinkleStar(
      initialRadius: initialRadius,
      evenStrokeLength: evenStrokeLength,
      oddStrokeLength: oddStrokeLength,
      strokeWidth: 1.0,
      evenStrokeColor: Colors.white,
      oddStrokeColor: Colors.white,
      numberOfLines: 8,
      animationDuration: const Duration(milliseconds: 500),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: twinkleStar,
      ),
    ));

    final RenderBox twinkleStarBox =
        tester.renderObject(find.byType(TwinkleStar));
    expect(
      twinkleStarBox.size.width,
      equals(2 * (initialRadius + math.max(evenStrokeLength, oddStrokeLength))),
    );
    expect(
      twinkleStarBox.size.height,
      equals(2 * (initialRadius + math.max(evenStrokeLength, oddStrokeLength))),
    );
  });
}
