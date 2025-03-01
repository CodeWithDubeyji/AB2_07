import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryColor = Color.fromRGBO(255, 0, 82, 1);
  static const Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color cardColor = Color.fromRGBO(82, 79, 79, 1);
  static const Color textDarkColor = Color.fromRGBO(50, 50, 50, 1);
  static const Color textLightColor = Color.fromRGBO(150, 150, 150, 1);
  static const Color iconColor = Color.fromRGBO(100, 100, 100, 1);

  // Dark Theme Colors
  static const Color primaryColorDark = Color.fromRGBO(255, 0, 82, 1);
  static const Color backgroundColorDark = Color.fromRGBO(18, 18, 18, 1);
  static const Color cardColorDark = Color.fromRGBO(30, 30, 30, 1);
  static const Color textDarkColorDark = Color.fromRGBO(240, 240, 240, 1);
  static const Color textLightColorDark = Color.fromRGBO(180, 180, 180, 1);
  static const Color iconColorDark = Color.fromRGBO(200, 200, 200, 1);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      background: backgroundColor,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: textDarkColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: textDarkColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textDarkColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textDarkColor,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: textLightColor,
        fontSize: 12,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: textDarkColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: iconColor,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundColorDark,
    cardColor: cardColorDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColorDark,
      secondary: primaryColorDark,
      background: backgroundColorDark,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: textDarkColorDark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: textDarkColorDark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: textDarkColorDark,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textDarkColorDark,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textDarkColorDark,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: textLightColorDark,
        fontSize: 12,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColorDark,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textDarkColorDark,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: textDarkColorDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColorDark),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: iconColorDark,
    ),
  );
}