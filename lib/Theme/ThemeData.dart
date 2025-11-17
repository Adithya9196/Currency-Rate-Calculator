import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.deepPurple,
    onPrimary: Colors.white,
    secondary: Colors.deepPurpleAccent,
    onSecondary: Colors.white,
    background: Colors.grey[100]!,
    onBackground: Colors.black87,
    surface: Colors.white,
    onSurface: Colors.black87,
    surfaceVariant: Colors.grey[200]!,
    onSurfaceVariant: Colors.grey[700]!,
    outline: Colors.grey[400]!,
    error: Colors.red,
    onError: Colors.white,
    shadow: Colors.grey.shade50,
    inverseSurface: Colors.grey[800]!,
    onInverseSurface: Colors.white,
    tertiary: Colors.deepPurple.shade200,
    onTertiary: Colors.white,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[400]!),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    hintStyle: TextStyle(color: Colors.grey[700]),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade100,
    foregroundColor: Colors.black87,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  ),
);


final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.deepPurple.shade200,
    onPrimary: Colors.black87,
    secondary: Colors.deepPurpleAccent,
    onSecondary: Colors.black87,
    background: Colors.grey[900]!,
    onBackground: Colors.white,
    surface: Colors.grey[850]!,
    onSurface: Colors.white,
    surfaceVariant: Colors.grey[800]!,
    onSurfaceVariant: Colors.grey[400]!,
    outline: Colors.grey[600]!,
    error: Colors.red.shade400,
    onError: Colors.black87,
    shadow: Colors.black,
    inverseSurface: Colors.grey[200]!,
    onInverseSurface: Colors.black87,
    tertiary: Colors.deepPurple.shade300,
    onTertiary: Colors.black87,
  ),
  cardTheme: CardTheme(
    color: Colors.grey[850],
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey[600]!),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple.shade200,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[600]!),
    ),
    hintStyle: TextStyle(color: Colors.grey[400]),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
