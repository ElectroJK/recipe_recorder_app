import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recipe_recorder_app/design/theme.dart';

class AboutPage extends StatelessWidget {
  final ThemeMode currentTheme;

  const AboutPage({super.key, required this.currentTheme});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = currentTheme == ThemeMode.dark;
    final gradient = isDarkMode ? getDarkGradient() : getLightGradient();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.aboutUsTitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AboutCard(
                  title: AppLocalizations.of(context)!.aboutRecipeRecorderTitle,
                  content: AppLocalizations.of(context)!.aboutRecipeRecorderContent,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: AppLocalizations.of(context)!.developersTitle,
                  content: AppLocalizations.of(context)!.developersContent,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: AppLocalizations.of(context)!.courseDetailsTitle,
                  content: AppLocalizations.of(context)!.courseDetailsContent,
                  isItalic: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isItalic;

  const AboutCard({
    super.key,
    required this.title,
    required this.content,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.lightGreenAccent
                    : const Color.fromARGB(255, 82, 204, 88),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}