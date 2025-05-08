import 'package:flutter/material.dart';

// Light theme colors (уютные, тёплые тона)
const _lightPrimary = Color(0xFFFFFBF2); // молочно-кремовый
const _lightSecondary = Color(0xFFFFF3E0); // персиковый фон
const _lightCard = Color(0xFFFFFFFF); // белый фон карточек
const _lightAccent = Color(0xFF8D6E63); // кофейный акцент
const _lightNavBar = Color(0xFFFFE0B2); // светло-оранжевый
const _lightNavBarIcon = Color(0xFF5D4037); // тёмный шоколад

// Dark theme colors (тёмные уютные оттенки)
const _darkPrimary = Color(0xFF1C1C1C); // тёмно-шоколадный
const _darkSecondary = Color(0xFF2C2C2C); // серо-коричневый
const _darkCard = Color(0xFF333333); // тёмная карточка
const _darkAccent = Color(0xFFFFA726); // акцент - карамель
const _darkNavBar = Color(0xFF2E2E2E); // тёмный фон
const _darkNavBarIcon = Color(0xFFFFCC80); // светлая карамель

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: _lightPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: _lightPrimary,
    elevation: 0,
    iconTheme: IconThemeData(color: _lightNavBarIcon),
    titleTextStyle: TextStyle(
      color: _lightNavBarIcon,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _lightNavBar,
    selectedItemColor: _lightNavBarIcon,
    unselectedItemColor: Colors.brown,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.brown),
    bodyMedium: TextStyle(color: Colors.black54),
  ),
  cardColor: _lightCard,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: _lightAccent,
    secondary: _lightSecondary,
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: _darkPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: _darkPrimary,
    elevation: 0,
    iconTheme: IconThemeData(color: _darkNavBarIcon),
    titleTextStyle: TextStyle(
      color: _darkNavBarIcon,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _darkNavBar,
    selectedItemColor: _darkNavBarIcon,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  cardColor: _darkCard,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkAccent,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
  ).copyWith(primary: _darkAccent, secondary: _darkSecondary),
);

LinearGradient getLightGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_lightSecondary, _lightPrimary],
  );
}

LinearGradient getDarkGradient() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_darkSecondary, _darkPrimary],
  );
}
