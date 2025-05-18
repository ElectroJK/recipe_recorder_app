import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';

class SettingsPage extends StatelessWidget {
  final ThemeMode currentTheme;
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;

  const SettingsPage({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.grey[300] : Colors.black;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.language, color: iconColor),
            title: Text(context.l10n.language),
            onTap: () => _showLanguageBottomSheet(context),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6, color: iconColor),
            title: Text(context.l10n.theme),
            subtitle: Text(_themeModeToString(context, currentTheme)),
            onTap: () => _showThemeBottomSheet(context),
          ),
        ],
      ),
    );
  }

  String _themeModeToString(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return context.l10n.light;
      case ThemeMode.dark:
        return context.l10n.dark;
      case ThemeMode.system:
      default:
        return context.l10n.systemDefault;
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n.english),
                onTap: () {
                  onLocaleChanged(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(context.l10n.russian),
                onTap: () {
                  onLocaleChanged(const Locale('ru'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(context.l10n.kazakh),
                onTap: () {
                  onLocaleChanged(const Locale('kk'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n.light),
                onTap: () {
                  onThemeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(context.l10n.dark),
                onTap: () {
                  onThemeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(context.l10n.systemDefault),
                onTap: () {
                  onThemeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
