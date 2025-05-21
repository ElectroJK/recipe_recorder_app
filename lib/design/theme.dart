import 'package:flutter/material.dart';

// Light theme colors
const _lightPrimary = Color(0xFFFAFCFA); // Pure light background
const _lightSecondary = Color(0xFFF2F7F4); // Subtle sage background
const _lightCard = Color(0xFFFFFFFF); // Pure white
const _lightAccent = Color(0xFF2C7A52); // Deep emerald
const _lightNavBar = Color(0xFFFFFFFF); // White navbar
const _lightNavBarIcon = Color(0xFF235C3E); // Dark forest

// Dark theme colors
const _darkPrimary = Color(0xFF0A1612); // Deep charcoal
const _darkSecondary = Color(0xFF0F1F1A); // Rich dark background
const _darkCard = Color(0xFF1A2C25); // Forest card
const _darkAccent = Color(0xFF3D9F6F); // Bright emerald
const _darkNavBar = Color(0xFF0C1914); // Dark nav
const _darkNavBarIcon = Color(0xFF4DAF7C); // Light emerald

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: _lightPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: _lightCard,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.05),
    iconTheme: const IconThemeData(color: _lightNavBarIcon),
    titleTextStyle: const TextStyle(
      color: _lightNavBarIcon,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _lightNavBar,
    selectedItemColor: _lightAccent,
    unselectedItemColor: Color(0xFF6B9F84),
    elevation: 8,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFF235C3E),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF2C7A52),
      fontSize: 15,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF1B4E35),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      fontSize: 22,
    ),
  ),
  cardColor: _lightCard,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightAccent,
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: _lightAccent.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: _lightAccent,
    secondary: _lightSecondary,
    surface: _lightCard,
    background: _lightPrimary,
    onBackground: const Color(0xFF235C3E),
    onSurface: const Color(0xFF2C7A52),
  ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: _darkPrimary,
  appBarTheme: AppBarTheme(
    backgroundColor: _darkCard,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.2),
    iconTheme: const IconThemeData(color: _darkNavBarIcon),
    titleTextStyle: const TextStyle(
      color: _darkNavBarIcon,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: _darkNavBar,
    selectedItemColor: _darkNavBarIcon,
    unselectedItemColor: Color(0xFF5B917C),
    elevation: 8,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFB4D9C8),
      fontSize: 15,
    ),
    titleLarge: TextStyle(
      color: Color(0xFF4DAF7C),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      fontSize: 22,
    ),
  ),
  cardColor: _darkCard,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkAccent,
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: _darkAccent.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
  ).copyWith(
    primary: _darkAccent,
    secondary: _darkSecondary,
    surface: _darkCard,
    background: _darkPrimary,
    onBackground: const Color(0xFFE0E0E0),
    onSurface: const Color(0xFF4DAF7C),
  ),
);

LinearGradient getLightGradient() {
  return const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF2F7F4),  // Light sage start
      Color(0xFFFAFCFA),  // Pure light middle
      Color(0xFFF7FAF8),  // Gentle light end
    ],
    stops: [0.0, 0.5, 1.0],
  );
}

LinearGradient getDarkGradient() {
  return const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F1F1A),  // Deep dark start
      Color(0xFF0A1612),  // Charcoal middle
      Color(0xFF0C1914),  // Rich dark end
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
