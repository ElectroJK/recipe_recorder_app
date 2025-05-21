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
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
                  icon: Icons.restaurant_menu_rounded,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: l10n.developersTitle,
                  content: l10n.developersContent,
                  icon: Icons.people_rounded,
                ),
                const SizedBox(height: 20),
                AboutCard(
                  title: l10n.courseDetailsTitle,
                  content: l10n.courseDetailsContent,
                  isItalic: true,
                  icon: Icons.school_rounded,
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
  final IconData icon;

  const AboutCard({
    super.key,
    required this.title,
    required this.content,
    this.isItalic = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF3D9F6F).withOpacity(0.1)
                : const Color(0xFF2C7A52).withOpacity(0.08),
            width: 1,
          ),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3D9F6F).withOpacity(0.1)
                          : const Color(0xFF2C7A52).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: isDark
                          ? const Color(0xFF4DAF7C)
                          : const Color(0xFF2C7A52),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: isDark
                            ? const Color(0xFF4DAF7C)
                            : const Color(0xFF2C7A52),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
