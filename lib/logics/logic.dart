import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _recipes = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  void addRecipe(String title, String description, String image) {
    final newRecipe = Recipe(
      id: UniqueKey().toString(),
      title: title,
      description: description,
      image: image,
    );
    _recipes.add(newRecipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }
}
