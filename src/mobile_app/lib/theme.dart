import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color.fromRGBO(244, 80, 30, 1);
  static const complementaryColor = Color.fromRGBO(30, 194, 244, 1);
  static const analogousUpperColor = Color.fromRGBO(244, 30, 87, 1);
  static const analogousLowerColor = Color.fromRGBO(244, 187, 30, 1);
  static const triadicUpperColor = Color.fromRGBO(194, 244, 30, 1);
  static const triadicLowerColor = Color.fromRGBO(30, 244, 32, 1);

  MaterialColor get primarySwatch {
    return createMaterialColor(primaryColor);
  }

  MaterialColor get complementarySwatch {
    return createMaterialColor(complementaryColor);
  }

  MaterialColor get analogousUpperSwatch {
    return createMaterialColor(analogousUpperColor);
  }

  MaterialColor get analogousLowerSwatch {
    return createMaterialColor(analogousLowerColor);
  }

  MaterialColor get triadicUpperSwatch {
    return createMaterialColor(triadicUpperColor);
  }

  MaterialColor get triadicLowerSwatch {
    return createMaterialColor(triadicLowerColor);
  }

  ThemeData build() {
    return ThemeData(
      primarySwatch: primarySwatch,
      highlightColor: complementaryColor,
      fontFamily: 'Poppins',
      // Solution to customize button border adapted from:
      // https://www.flutterbeads.com/button-border-flutter/
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  // Function adapted from:
  // https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red,
        g = color.green,
        b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
