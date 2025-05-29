import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/models/recipe.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';

class FavoritesPage extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoritesPage({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favoritesPageTitle)),
      body:
          favoriteRecipes.isEmpty
              ? Center(child: Text(context.l10n.favoritesPageEmpty))
              : ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading:
                          recipe.image.isNotEmpty
                              ? Image.network(
                                recipe.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image),
                              )
                              : const Icon(Icons.image_not_supported),
                      title: Text(recipe.title),
                      subtitle: Text(recipe.description),
                    ),
                  );
                },
              ),
    );
  }
}
