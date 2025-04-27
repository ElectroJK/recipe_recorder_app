import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/models/recipe.dart';

class FavoritesPage extends StatelessWidget {
  final Set<Recipe> favoriteRecipes; // ✅ принимаем список рецептов

  const FavoritesPage({
    super.key,
    required this.favoriteRecipes,
  }); // ✅ передаём через конструктор

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body:
          favoriteRecipes.isEmpty
              ? const Center(child: Text('No favorites yet!'))
              : ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes.elementAt(index);
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(
                        recipe.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      ),
                      title: Text(recipe.title),
                      subtitle: Text(recipe.description),
                    ),
                  );
                },
              ),
    );
  }
}
