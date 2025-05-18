import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RecipeController() {
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('recipes').get();
      _recipes =
          snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
    } catch (e) {
      print('Error fetching recipes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecipe(Map<String, dynamic> recipe) async {
    try {
      await _firestore.collection('recipes').add(recipe);
      await fetchRecipes();
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _firestore.collection('recipes').doc(id).delete();
      await fetchRecipes();
    } catch (e) {
      print('Error deleting recipe: $e');
    }
  }
}
