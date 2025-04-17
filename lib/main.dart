import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'homePage/home_page.dart';
import 'design/theme.dart';

void main() {
  runApp(const RecipeRecorderApp());
}

class RecipeRecorderApp extends StatefulWidget {
  const RecipeRecorderApp({super.key});

  @override
  State<RecipeRecorderApp> createState() => _RecipeRecorderAppState();
}

class _RecipeRecorderAppState extends State<RecipeRecorderApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _changeLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Recorder',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('kk', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Theme(
        data: _themeMode == ThemeMode.dark ? darkTheme : lightTheme,
        child: Builder(
          builder: (context) {
            return HomePage(
              onThemeChanged: _changeTheme,
              onLocaleChanged: _changeLocale,
              currentTheme: _themeMode,
            );
          },
        ),
      ),
    );
  }
}
