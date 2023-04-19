import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/common/widgets/twinkle_container.dart';
import 'package:trivial/common/widgets/twinkle_star.dart';

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

    testWidgets(
      'Twinkles are spawned at the correct rate specified by `twinkleWaitDuration` and `style.animationDuration`',
      (tester) async {
        const int animationDuration = 700;
        const int waitDuration = 300;
        const Key containerKey = Key('__twinkleContainer__');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                key: containerKey,
                twinkleWaitDuration: waitDuration,
                starStyle: const TwinkleStarStyle(
                  animationDuration: animationDuration,
                ),
                child: Container(),
              ),
            ),
          ),
        );

        final twinkleFinder = find.descendant(
          of: find.byKey(containerKey),
          matching: find.byType(TwinkleStar),
        );

        expect(twinkleFinder, findsOneWidget);

        await tester.pump(const Duration(milliseconds: animationDuration + 5));

        expect(twinkleFinder, findsNothing);

        await tester.pump(const Duration(milliseconds: waitDuration));

        expect(twinkleFinder, findsOneWidget);
      },
    );

    testWidgets(
      'when the starStyle parameter is not passed in, the default TwinkleStarStyle is used',
      (tester) async {
        const Key containerKey = Key('__twinkleContainer__');
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                key: containerKey,
                child: Container(),
              ),
            ),
          ),
        );

        final containerFinder = find.byKey(containerKey);
        final starFinder = find.descendant(
          of: containerFinder,
          matching: find.byType(TwinkleStar),
        );

        final widget =
            tester.widget(find.byKey(containerKey)) as TwinkleContainer;
        final star = tester.widget(starFinder) as TwinkleStar;

        expect(widget.starStyle, equals(const TwinkleStarStyle()));
        expect(star.style, equals(const TwinkleStarStyle()));
      },
    );

    testWidgets(
      'when the starStyle parameter is passed in, spawns stars using it',
      (tester) async {
        const Key containerKey = Key('__twinkleContainer__');
        const TwinkleStarStyle testStyle = TwinkleStarStyle(
          animationDuration: 152,
          evenStrokeLength: 32,
          oddStrokeLength: 15,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                key: containerKey,
                starStyle: testStyle,
                child: Container(),
              ),
            ),
          ),
        );

        final containerFinder = find.byKey(containerKey);
        final starFinder = find.descendant(
          of: containerFinder,
          matching: find.byType(TwinkleStar),
        );

        final widget =
            tester.widget(find.byKey(containerKey)) as TwinkleContainer;
        final star = tester.widget(starFinder) as TwinkleStar;

        expect(widget.starStyle, equals(testStyle));
        expect(star.style, equals(testStyle));
      },
    );

    testWidgets(
        'spawns twinkles within the specified spawn area across at least 50 iterations',
        (WidgetTester tester) async {
      const spawnAreaHeight = 200.0;
      const spawnAreaWidth = 300.0;
      const verticalAreaInset = 20.0;
      const horizontalAreaInset = 40.0;
      const animationDuration = 700;
      const waitDuration = 300;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwinkleContainer(
              spawnAreaHeight: spawnAreaHeight,
              spawnAreaWidth: spawnAreaWidth,
              verticalAreaInset: verticalAreaInset,
              horizontalAreaInset: horizontalAreaInset,
              twinkleWaitDuration: waitDuration,
              starStyle: const TwinkleStarStyle(
                animationDuration: animationDuration,
              ),
              child: Container(),
            ),
          ),
        ),
      );

      for (int i = 0; i < 50; i++) {
        // Get the list of spawned twinkles
        final twinkleStarFinder = find.byType(TwinkleStar);
        final twinkleStar = tester.widget(twinkleStarFinder) as TwinkleStar;

        // Verify that all spawned twinkles are within the specified spawn area and area insets
        final position = tester.getTopLeft(find.byWidget(twinkleStar));
        expect(
          position.dx,
          greaterThanOrEqualTo(twinkleStar.boxDimensions + horizontalAreaInset),
        );
        expect(
          position.dx,
          lessThanOrEqualTo(spawnAreaWidth -
              (twinkleStar.boxDimensions + horizontalAreaInset)),
        );
        expect(
          position.dy,
          greaterThanOrEqualTo(twinkleStar.boxDimensions + verticalAreaInset),
        );
        expect(
          position.dy,
          lessThanOrEqualTo(spawnAreaHeight -
              (twinkleStar.boxDimensions + verticalAreaInset)),
        );
        await tester.pump(const Duration(milliseconds: animationDuration + 5));
        await tester.pump(const Duration(milliseconds: waitDuration));
      }
    });

    testWidgets('each spawned twinkle is assigned a unique key',
        (WidgetTester tester) async {
      const animationDuration = 700;
      const waitDuration = 300;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwinkleContainer(
              twinkleWaitDuration: waitDuration,
              starStyle: const TwinkleStarStyle(
                animationDuration: animationDuration,
              ),
              child: Container(),
            ),
          ),
        ),
      );

      List<String> keys = [];

      for (int i = 0; i < 50; i++) {
        // Get the list of spawned twinkles
        final twinkleStarFinder = find.byType(TwinkleStar);
        final twinkleStar = tester.widget(twinkleStarFinder) as TwinkleStar;

        final newKey = twinkleStar.key.toString();

        expect(keys.any((element) => element == newKey), equals(false));

        keys.add(twinkleStar.key.toString());

        await tester.pump(const Duration(milliseconds: animationDuration + 5));
        await tester.pump(const Duration(milliseconds: waitDuration));
      }
    });
  });
}
