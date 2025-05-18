import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserSettingsProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  UserSettingsProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadSettings(user.uid);
      } else {
        _themeMode = ThemeMode.system;
        _locale = const Locale('en');
        notifyListeners();
      }
    });
  }

  Future<void> _loadSettings(String userId) async {
    final doc =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('settings')
            .doc('preferences')
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      final themeStr = data['themeMode'] as String? ?? 'system';
      final localeStr = data['locale'] as String? ?? 'en';

      _themeMode = _stringToThemeMode(themeStr);
      _locale = Locale(localeStr);
      notifyListeners();
    } else {
      _themeMode = ThemeMode.system;
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('preferences')
        .set({
          'themeMode': _themeModeToString(mode),
          'locale': _locale.languageCode,
        }, SetOptions(merge: true));
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('settings')
        .doc('preferences')
        .set({
          'themeMode': _themeModeToString(_themeMode),
          'locale': locale.languageCode,
        }, SetOptions(merge: true));
  }

  ThemeMode _stringToThemeMode(String str) {
    switch (str) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
