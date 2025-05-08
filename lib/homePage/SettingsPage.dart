import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Function(ThemeMode) onThemeChanged = args['onThemeChanged'];
    final Function(Locale) onLocaleChanged = args['onLocaleChanged'];
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
            onTap: () => _showLanguageBottomSheet(context, onLocaleChanged),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6, color: iconColor),
            title: Text(context.l10n.theme),
            onTap: () => _showThemeBottomSheet(context, onThemeChanged),
          ),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    Function(Locale) onLocaleChanged,
  ) {
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

  void _showThemeBottomSheet(
    BuildContext context,
    Function(ThemeMode) onThemeChanged,
  ) {
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
