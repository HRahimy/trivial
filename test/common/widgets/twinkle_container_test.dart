import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivial/common/common_keys.dart';
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

    group('[keys]', () {
      testWidgets(
          '`twinkleContainer` exists and is an instance of TwinkleContainer',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.byKey(CommonKeys.twinkleContainer);

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder);

        expect(widget.runtimeType, TwinkleContainer);
      });

      testWidgets('`spawnArea` widget exists and is a SizedBox',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                child: Container(),
              ),
            ),
          ),
        );

        final spawnAreaFinder =
            find.byKey(CommonKeys.twinkleContainerSpawnArea);

        expect(spawnAreaFinder, findsOneWidget);

        final widget = tester.widget(spawnAreaFinder);

        expect(widget.runtimeType, SizedBox);
      });

      testWidgets(
          'first `twinkleStar` widget exists and is a TwinkleStar object',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.byKey(CommonKeys.twinkleContainerStar('1'));

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder);

        expect(widget.runtimeType, TwinkleStar);
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
        'given default alignment, spawns twinkles within the specified spawn area across at least 50 iterations',
        (WidgetTester tester) async {
      const spawnAreaHeight = 200.0;
      const spawnAreaWidth = 300.0;
      const animationDuration = 700;
      const waitDuration = 300;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TwinkleContainer(
              spawnAreaHeight: spawnAreaHeight,
              spawnAreaWidth: spawnAreaWidth,
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
          lessThanOrEqualTo(spawnAreaWidth - (twinkleStar.boxDimensions)),
        );
        expect(
          position.dy,
          lessThanOrEqualTo(spawnAreaHeight - (twinkleStar.boxDimensions)),
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

    group('[spawnAreaHeight] param', () {
      testWidgets(
        'when passed in, used to set the height of spawnArea container',
        (tester) async {
          const spawnAreaHeight = 200.0;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TwinkleContainer(
                  spawnAreaHeight: spawnAreaHeight,
                  child: Container(),
                ),
              ),
            ),
          );

          final size =
              tester.getSize(find.byKey(CommonKeys.twinkleContainerSpawnArea));

          expect(size.height, equals(spawnAreaHeight));
        },
      );

      testWidgets(
        'when not passed in, the default height (half the screen height) is used',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TwinkleContainer(
                  child: Container(),
                ),
              ),
            ),
          );

          // Get height of the render area
          final top = tester.getTopLeft(find.byType(MaterialApp));
          final bottom = tester.getBottomLeft(find.byType(MaterialApp));
          final screenHeight = (top - bottom).distance;

          final size =
              tester.getSize(find.byKey(CommonKeys.twinkleContainerSpawnArea));
          expect(size.height, equals(screenHeight / 2));
        },
      );
    });

    group('[spawnAreaWidth] param', () {
      testWidgets(
        'when passed in, used to set the height of spawnArea container',
        (tester) async {
          const spawnAreaWidth = 200.0;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TwinkleContainer(
                  spawnAreaWidth: spawnAreaWidth,
                  child: Container(),
                ),
              ),
            ),
          );

          final size =
              tester.getSize(find.byKey(CommonKeys.twinkleContainerSpawnArea));

          expect(size.width, equals(spawnAreaWidth));
        },
      );

      testWidgets(
        'when not passed in, the default width (screen width) is used',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: TwinkleContainer(
                  child: Container(),
                ),
              ),
            ),
          );

          // Get width of the render area
          final left = tester.getTopLeft(find.byType(MaterialApp));
          final right = tester.getTopRight(find.byType(MaterialApp));
          final screenWidth = (left - right).distance;

          final size =
              tester.getSize(find.byKey(CommonKeys.twinkleContainerSpawnArea));
          expect(size.width, equals(screenWidth));
        },
      );
    });

    group('[spawnAreaPadding] param', () {
      testWidgets('when passed in, correct padding is added around spawn area',
          (tester) async {
        const testPadding = EdgeInsets.all(32);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                spawnAreaPadding: testPadding,
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.descendant(
          of: find.byKey(CommonKeys.twinkleContainer),
          matching: find.ancestor(
            of: find.byKey(CommonKeys.twinkleContainerSpawnArea),
            matching: find.byType(Padding),
          ),
        );

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder) as Padding;

        expect(widget.padding, equals(testPadding));
      });

      testWidgets('when not passed in, no padding is added around spawn area',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.descendant(
          of: find.byKey(CommonKeys.twinkleContainer),
          matching: find.ancestor(
            of: find.byKey(CommonKeys.twinkleContainerSpawnArea),
            matching: find.byType(Padding),
          ),
        );

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder) as Padding;

        expect(widget.padding, equals(EdgeInsets.zero));
      });
    });

    group('[spawnAreaAlignment] param', () {
      testWidgets('when passed in, alignment is applied to spawn area',
          (tester) async {
        const testAlignment = Alignment.bottomRight;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                spawnAreaAlignment: testAlignment,
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.descendant(
          of: find.byKey(CommonKeys.twinkleContainer),
          matching: find.ancestor(
            of: find.byKey(CommonKeys.twinkleContainerSpawnArea),
            matching: find.byType(Align),
          ),
        );

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder) as Align;

        expect(widget.alignment, equals(testAlignment));
      });

      testWidgets(
          'when not passed in, default (top-left) alignment is applied to spawn area',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TwinkleContainer(
                child: Container(),
              ),
            ),
          ),
        );

        final finder = find.descendant(
          of: find.byKey(CommonKeys.twinkleContainer),
          matching: find.ancestor(
            of: find.byKey(CommonKeys.twinkleContainerSpawnArea),
            matching: find.byType(Align),
          ),
        );

        expect(finder, findsOneWidget);

        final widget = tester.widget(finder) as Align;

        expect(widget.alignment, equals(Alignment.topLeft));
      });
    });

    group('Exceptions', () {
      test(
          'a value lesser than 50 for `twinkleWaitDuration` throws assertion error',
          () {
        expect(
          () => TwinkleContainer(
            twinkleWaitDuration: 32,
            child: Container(),
          ),
          throwsAssertionError,
        );
      });

      testWidgets(
          'passing a value of 0 or less for `spawnAreaHeight` throws assertion error',
          (tester) async {
        expect(
          () => TwinkleContainer(
            spawnAreaHeight: -5,
            child: Container(),
          ),
          throwsAssertionError,
        );
      });

      testWidgets(
          'passing a value of 0 or less for `spawnAreaWidth` throws assertion error',
          (tester) async {
        expect(
          () => TwinkleContainer(
            spawnAreaWidth: -5,
            child: Container(),
          ),
          throwsAssertionError,
        );
      });
    });
  });
}
