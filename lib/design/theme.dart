import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  cardColor: Color(0xFFF5F5F5),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.grey),
  ),
  cardColor: Color(0xFF1E1E1E),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  ),
);
