import 'package:flutter/material.dart';

// Light theme colors
const _lightPrimary = Colors.white;
const _lightSecondary = Color.fromARGB(255, 184, 255, 190); // Light green
const _lightCard = Color(0xFFF5F5F5);

// Dark theme colors
const _darkPrimary = Colors.black;
const _darkSecondary = Color(0xFF1B5E20); // Dark green
const _darkCard = Color.fromARGB(255, 30, 30, 30);

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: _lightPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: _lightPrimary,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  cardColor: const Color.fromARGB(255, 248, 255, 249),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: _darkPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: _darkPrimary,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
  ),
  cardColor: const Color.fromARGB(255, 138, 164, 147),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[900],
      foregroundColor: Colors.white,
    ),
  ),
);

LinearGradient getLightGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_lightPrimary, _lightSecondary],
  );
}

LinearGradient getDarkGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_darkPrimary, _darkSecondary],
  );
}