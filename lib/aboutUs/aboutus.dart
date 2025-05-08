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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          l10n.aboutUsTitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AboutCard(
                  title: l10n.aboutRecipeRecorderTitle,
                  content: l10n.aboutRecipeRecorderContent,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: l10n.developersTitle,
                  content: l10n.developersContent,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: l10n.courseDetailsTitle,
                  content: l10n.courseDetailsContent,
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
      color: Theme.of(context).cardColor.withOpacity(0.92),
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
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF81C784)
                        : const Color(0xFF388E3C),
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
