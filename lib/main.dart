import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'HomePage/GuestHomePage.dart';
import 'package:recipe_recorder_app/userData/UserSettingProvider.dart';
import 'models/recipe_controller.dart';
import 'homePage/home_page.dart';
import 'userData/login_page.dart';
import 'design/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeController()),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettingsProvider>(context);

    return MaterialApp(
      title: 'Recipe Recorder',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: userSettings.themeMode,
      locale: userSettings.locale,
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/login_page',
      routes: {
        '/login_page':
            (context) => LoginPage(
              currentTheme: userSettings.themeMode,
              onThemeChanged: userSettings.setThemeMode,
              onLocaleChanged: userSettings.setLocale,
            ),
        '/guest_home': (context) => const GuestHomePage(),
      },
    );
  }
}
