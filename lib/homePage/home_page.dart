import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../aboutUs/aboutus.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';
import 'package:recipe_recorder_app/logics/logic.dart';

class HomePage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Map<String, String>> localRecipes;
  Set<Map<String, String>> favoriteRecipes = {}; // теперь по объекту

  @override
  void initState() {
    super.initState();
    localRecipes = List<Map<String, String>>.from(recipes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _showThemeBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: AnimatedList(
              key: _listKey,
              initialItemCount: localRecipes.length,
              itemBuilder: (context, index, animation) {
                final recipe = localRecipes[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Slidable(
                      key: ValueKey(recipe['title'] ?? index),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              setState(() {
                                if (favoriteRecipes.contains(recipe)) {
                                  favoriteRecipes.remove(recipe);
                                } else {
                                  favoriteRecipes.add(recipe);
                                }
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    favoriteRecipes.contains(recipe)
                                        ? 'Added to favorites'
                                        : 'Removed from favorites',
                                  ),
                                ),
                              );
                            },
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            icon: Icons.star,
                            label: 'Favorites',
                          ),
                          SlidableAction(
                            onPressed: (_) async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Удалить рецепт?'),
                                      content: const Text(
                                        'Ты уверен, что хочешь удалить этот рецепт?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Отмена'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Удалить'),
                                        ),
                                      ],
                                    ),
                              );

                              if (shouldDelete == true) {
                                _removeRecipe(recipe);
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          _recipeCard(
                            context,
                            context.l10n.getRecipeTitle(index + 1),
                            context.l10n.getRecipeDescription(index + 1),
                            recipe['image']!,
                          ),
                          if (favoriteRecipes.contains(recipe))
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(Icons.star, color: Colors.orange),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _recipeCard(
    BuildContext context,
    String title,
    String description,
    String imageUrl,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            height: 180,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeRecipe(Map<String, String> recipeToRemove) {
    final index = localRecipes.indexOf(recipeToRemove);
    if (index == -1) return;

    final removedCard = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _recipeCard(
        context,
        context.l10n.getRecipeTitle(index + 1),
        context.l10n.getRecipeDescription(index + 1),
        recipeToRemove['image']!,
      ),
    );

    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          SizeTransition(sizeFactor: animation, child: removedCard),
      duration: const Duration(milliseconds: 300),
    );

    setState(() {
      localRecipes.removeAt(index);
      favoriteRecipes.remove(recipeToRemove);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recipe deleted')));
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.language,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _languageTile(context, 'English', const Locale('en')),
              _languageTile(context, 'Русский', const Locale('ru')),
              _languageTile(context, 'Қазақша', const Locale('kk')),
            ],
          ),
        );
      },
    );
  }

  Widget _languageTile(BuildContext context, String name, Locale locale) {
    final isSelected =
        Localizations.localeOf(context).languageCode == locale.languageCode;
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
      onTap: () {
        widget.onLocaleChanged(locale);
        Navigator.pop(context);
      },
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light Theme'),
              onTap: () {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Theme'),
              onTap: () {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
