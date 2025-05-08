import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:recipe_recorder_app/homePage/FavoritesPage.dart';
import 'package:recipe_recorder_app/homePage/SettingsPage.dart';
import '../aboutUs/aboutus.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';
import 'package:recipe_recorder_app/logics/logic.dart';
import 'package:recipe_recorder_app/design/theme.dart';
import 'package:recipe_recorder_app/models/recipe.dart';

class HomePage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;
  final ThemeMode currentTheme;

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Recipe> favoriteRecipes = {};

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.currentTheme == ThemeMode.dark;
    final gradient = isDarkMode ? getDarkGradient() : getLightGradient();
    final recipes = context.watch<RecipeProvider>().recipes;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(context.l10n.appTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            AboutPage(currentTheme: widget.currentTheme),
                  ),
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
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Slidable(
                      key: ValueKey(recipe.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _toggleFavorite(recipe, context),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            icon: Icons.star,
                            label: context.l10n.favoritesLabel,
                          ),
                          SlidableAction(
                            onPressed: (_) => _confirmDelete(recipe, context),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: context.l10n.delete,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          _recipeCard(
                            context,
                            recipe.title,
                            recipe.description,
                            recipe.image,
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
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddRecipeDialog(context),
          backgroundColor: isDarkMode ? Colors.white : Colors.grey,
          child: Icon(
            Icons.add,
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: context.l10n.bottomNavHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: context.l10n.bottomNavFavorites,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: context.l10n.bottomNavSettings,
            ),
          ],
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          FavoritesPage(favoriteRecipes: favoriteRecipes),
                ),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                  settings: RouteSettings(
                    arguments: {
                      'onThemeChanged': widget.onThemeChanged,
                      'onLocaleChanged': widget.onLocaleChanged,
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.addRecipe),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.titleLabel,
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: context.l10n.descriptionLabel,
                  ),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: context.l10n.imageLabel,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    context.read<RecipeProvider>().addRecipe(
                      titleController.text,
                      descriptionController.text,
                      imageController.text,
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text(context.l10n.add),
              ),
            ],
          ),
    );
  }

  Future<void> _confirmDelete(Recipe recipe, BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.deleteRecipeTitle),
            content: Text(context.l10n.deleteRecipeConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.delete),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      context.read<RecipeProvider>().removeRecipe(recipe.id);
    }
  }

  void _toggleFavorite(Recipe recipe, BuildContext context) {
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
              ? context.l10n.recipeAddedToFavorites(recipe.title)
              : context.l10n.recipeRemovedFromFavorites(recipe.title),
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
      color: Theme.of(context).cardColor.withOpacity(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 180,
                  child: Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  ),
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
}
