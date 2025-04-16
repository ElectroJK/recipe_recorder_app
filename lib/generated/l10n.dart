// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Recipe Recorder`
  String get appTitle {
    return Intl.message(
      'Recipe Recorder',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `System Default`
  String get systemDefault {
    return Intl.message(
      'System Default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Light theme selected`
  String get lightThemeSelected {
    return Intl.message(
      'Light theme selected',
      name: 'lightThemeSelected',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme selected`
  String get darkThemeSelected {
    return Intl.message(
      'Dark theme selected',
      name: 'darkThemeSelected',
      desc: '',
      args: [],
    );
  }

  /// `System theme selected`
  String get systemThemeSelected {
    return Intl.message(
      'System theme selected',
      name: 'systemThemeSelected',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Russian`
  String get russian {
    return Intl.message('Russian', name: 'russian', desc: '', args: []);
  }

  /// `Kazakh`
  String get kazakh {
    return Intl.message('Kazakh', name: 'kazakh', desc: '', args: []);
  }

  /// `English selected`
  String get englishSelected {
    return Intl.message(
      'English selected',
      name: 'englishSelected',
      desc: '',
      args: [],
    );
  }

  /// `Russian selected`
  String get russianSelected {
    return Intl.message(
      'Russian selected',
      name: 'russianSelected',
      desc: '',
      args: [],
    );
  }

  /// `Kazakh selected`
  String get kazakhSelected {
    return Intl.message(
      'Kazakh selected',
      name: 'kazakhSelected',
      desc: '',
      args: [],
    );
  }

  /// `Spaghetti Carbonara`
  String get recipeSpaghettiCarbonaraTitle {
    return Intl.message(
      'Spaghetti Carbonara',
      name: 'recipeSpaghettiCarbonaraTitle',
      desc: '',
      args: [],
    );
  }

  /// `Creamy pasta with bacon and parmesan.`
  String get recipeSpaghettiCarbonaraDescription {
    return Intl.message(
      'Creamy pasta with bacon and parmesan.',
      name: 'recipeSpaghettiCarbonaraDescription',
      desc: '',
      args: [],
    );
  }

  /// `Chicken Curry`
  String get recipeChickenCurryTitle {
    return Intl.message(
      'Chicken Curry',
      name: 'recipeChickenCurryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Spicy Indian-style curry with chicken.`
  String get recipeChickenCurryDescription {
    return Intl.message(
      'Spicy Indian-style curry with chicken.',
      name: 'recipeChickenCurryDescription',
      desc: '',
      args: [],
    );
  }

  /// `Beef Stroganoff`
  String get recipeBeefStroganoffTitle {
    return Intl.message(
      'Beef Stroganoff',
      name: 'recipeBeefStroganoffTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tender beef in mushroom cream sauce.`
  String get recipeBeefStroganoffDescription {
    return Intl.message(
      'Tender beef in mushroom cream sauce.',
      name: 'recipeBeefStroganoffDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tuna Salad`
  String get recipeTunaSaladTitle {
    return Intl.message(
      'Tuna Salad',
      name: 'recipeTunaSaladTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fresh and quick salad with tuna and veggies.`
  String get recipeTunaSaladDescription {
    return Intl.message(
      'Fresh and quick salad with tuna and veggies.',
      name: 'recipeTunaSaladDescription',
      desc: '',
      args: [],
    );
  }

  /// `Pancakes`
  String get recipePancakesTitle {
    return Intl.message(
      'Pancakes',
      name: 'recipePancakesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fluffy pancakes with maple syrup.`
  String get recipePancakesDescription {
    return Intl.message(
      'Fluffy pancakes with maple syrup.',
      name: 'recipePancakesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tomato Soup`
  String get recipeTomatoSoupTitle {
    return Intl.message(
      'Tomato Soup',
      name: 'recipeTomatoSoupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Warm soup with fresh tomatoes and herbs.`
  String get recipeTomatoSoupDescription {
    return Intl.message(
      'Warm soup with fresh tomatoes and herbs.',
      name: 'recipeTomatoSoupDescription',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUsTitle {
    return Intl.message('About Us', name: 'aboutUsTitle', desc: '', args: []);
  }

  /// `About Recipe Recorder App`
  String get aboutRecipeRecorderTitle {
    return Intl.message(
      'About Recipe Recorder App',
      name: 'aboutRecipeRecorderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recipe Recorder App helps users efficiently save and manage their favorite recipes. With an integrated database, users can securely store and access recipes anytime. The app also provides cooking tips and suggestions to enhance your culinary skills.`
  String get aboutRecipeRecorderContent {
    return Intl.message(
      'Recipe Recorder App helps users efficiently save and manage their favorite recipes. With an integrated database, users can securely store and access recipes anytime. The app also provides cooking tips and suggestions to enhance your culinary skills.',
      name: 'aboutRecipeRecorderContent',
      desc: '',
      args: [],
    );
  }

  /// `Developers`
  String get developersTitle {
    return Intl.message(
      'Developers',
      name: 'developersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Developed by:\n\nTanatkanov Kadyrulan\nAsanali Ashimov\nZholaman Yerzhan`
  String get developersContent {
    return Intl.message(
      'Developed by:\n\nTanatkanov Kadyrulan\nAsanali Ashimov\nZholaman Yerzhan',
      name: 'developersContent',
      desc: '',
      args: [],
    );
  }

  /// `Course Details`
  String get courseDetailsTitle {
    return Intl.message(
      'Course Details',
      name: 'courseDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Course: Crossplatform Development, Astana IT University\nMentor: Assistant Professor Abzal Kyzyrkanov`
  String get courseDetailsContent {
    return Intl.message(
      'Course: Crossplatform Development, Astana IT University\nMentor: Assistant Professor Abzal Kyzyrkanov',
      name: 'courseDetailsContent',
      desc: '',
      args: [],
    );
  }

  /// `Spaghetti Carbonara`
  String get recipeTitle1 {
    return Intl.message(
      'Spaghetti Carbonara',
      name: 'recipeTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Creamy pasta with bacon and parmesan.`
  String get recipeDescription1 {
    return Intl.message(
      'Creamy pasta with bacon and parmesan.',
      name: 'recipeDescription1',
      desc: '',
      args: [],
    );
  }

  /// `Chicken Curry`
  String get recipeTitle2 {
    return Intl.message(
      'Chicken Curry',
      name: 'recipeTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Spicy Indian-style curry with chicken.`
  String get recipeDescription2 {
    return Intl.message(
      'Spicy Indian-style curry with chicken.',
      name: 'recipeDescription2',
      desc: '',
      args: [],
    );
  }

  /// `Beef Stroganoff`
  String get recipeTitle3 {
    return Intl.message(
      'Beef Stroganoff',
      name: 'recipeTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Tender beef in mushroom cream sauce.`
  String get recipeDescription3 {
    return Intl.message(
      'Tender beef in mushroom cream sauce.',
      name: 'recipeDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Tuna Salad`
  String get recipeTitle4 {
    return Intl.message('Tuna Salad', name: 'recipeTitle4', desc: '', args: []);
  }

  /// `Fresh and quick salad with tuna and veggies.`
  String get recipeDescription4 {
    return Intl.message(
      'Fresh and quick salad with tuna and veggies.',
      name: 'recipeDescription4',
      desc: '',
      args: [],
    );
  }

  /// `Pancakes`
  String get recipeTitle5 {
    return Intl.message('Pancakes', name: 'recipeTitle5', desc: '', args: []);
  }

  /// `Fluffy pancakes with maple syrup.`
  String get recipeDescription5 {
    return Intl.message(
      'Fluffy pancakes with maple syrup.',
      name: 'recipeDescription5',
      desc: '',
      args: [],
    );
  }

  /// `Tomato Soup`
  String get recipeTitle6 {
    return Intl.message(
      'Tomato Soup',
      name: 'recipeTitle6',
      desc: '',
      args: [],
    );
  }

  /// `Warm soup with fresh tomatoes and herbs.`
  String get recipeDescription6 {
    return Intl.message(
      'Warm soup with fresh tomatoes and herbs.',
      name: 'recipeDescription6',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
