import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/common/widgets/twinkle_container.dart';

void main() {
  group('[TwinkleContainer]', () {
    group('[child]', () {
      testWidgets('displays child', (tester) async {
        const Key containerKey = Key('__twinkleContainer__');
        const Key childKey = Key('__childKey__');
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                key: containerKey,
                child: Center(
                  key: childKey,
                  child: Text(
                    'test text',
                  ),
                ),
              ),
            ),
          ),
        );

        final childFinder = find.descendant(
          of: find.byKey(containerKey),
          matching: find.byKey(childKey),
        );

        final childWidget = tester.widget(childFinder);

        expect(childFinder, findsOneWidget);
        expect(childWidget.runtimeType, equals(Center));
      });
    });

    // testWidgets(
    //     'TwinkleContainer should spawn twinkles within the specified spawn area',
    //     (WidgetTester tester) async {
    //   final spawnAreaHeight = 200.0;
    //   final spawnAreaWidth = 300.0;
    //   final verticalAreaInset = 20.0;
    //   final horizontalAreaInset = 40.0;
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Scaffold(
    //         body: TwinkleContainer(
    //           spawnAreaHeight: spawnAreaHeight,
    //           spawnAreaWidth: spawnAreaWidth,
    //           verticalAreaInset: verticalAreaInset,
    //           horizontalAreaInset: horizontalAreaInset,
    //           child: Container(),
    //         ),
    //       ),
    //     ),
    //   );
    //
    //   await tester.pumpAndSettle(const Duration(milliseconds: 1000));
    //
    //   final twinkleFinder = find.byType(TwinkleContainer);
    //   final twinkleContainer = tester.widget<TwinkleContainer>(twinkleFinder);
    //
    //   // Get the list of spawned twinkles
    //   final twinkleStarFinder = find.byType(TwinkleStar);
    //   final twinkleStars =
    //       tester.widgetList(twinkleStarFinder).toList();
    //
    //   // Verify that all spawned twinkles are within the specified spawn area and area insets
    //   for (final twinkleStar in twinkleStars) {
    //     final position = tester.getTopLeft(find.byWidget(twinkleStar));
    //     expect(
    //       position.dx,
    //       greaterThanOrEqualTo((twinkleStar as TwinkleStar).boxDimensions + horizontalAreaInset),
    //     );
    //     expect(
    //       position.dx,
    //       lessThanOrEqualTo(spawnAreaWidth -
    //           (twinkleStar.boxDimensions + horizontalAreaInset)),
    //     );
    //     expect(
    //       position.dy,
    //       greaterThanOrEqualTo(twinkleStar.boxDimensions + verticalAreaInset),
    //     );
    //     expect(
    //       position.dy,
    //       lessThanOrEqualTo(spawnAreaHeight -
    //           (twinkleStar.boxDimensions + verticalAreaInset)),
    //     );
    //   }
    // });
  });
}
