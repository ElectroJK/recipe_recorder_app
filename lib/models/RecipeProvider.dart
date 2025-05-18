import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _recipes = [];
  List<Recipe> get recipes => List.unmodifiable(_recipes);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSubscription;

  RecipeProvider() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadRecipesFromFirestore(user.uid);
      } else {
        _recipes.clear();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> addRecipe(String title, String description, String image) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef =
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .doc();

    final newRecipe = Recipe(
      id: docRef.id,
      title: title,
      description: description,
      image: image,
      favorites: false,
    );

    _recipes.add(newRecipe);
    notifyListeners();

    await docRef.set({
      'id': newRecipe.id,
      'title': newRecipe.title,
      'description': newRecipe.description,
      'image': newRecipe.image,
      'favorites': newRecipe.favorites,
    });
  }

  Future<void> removeRecipe(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(id)
        .delete();
  }

  Future<void> toggleFavoriteRecipe(Recipe recipe) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index == -1) return;

    final updatedRecipe = recipe.copyWith(favorites: !recipe.favorites);
    _recipes[index] = updatedRecipe;
    notifyListeners();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipe.id)
        .update({'favorites': updatedRecipe.favorites});
  }

  Future<void> _loadRecipesFromFirestore(String userId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('recipes')
            .get();

    _recipes
      ..clear()
      ..addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return Recipe(
            id: data['id'] ?? doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            image: data['image'] ?? '',
            favorites: data['favorites'] ?? false,
          );
        }),
      );

    notifyListeners();
  }
}
