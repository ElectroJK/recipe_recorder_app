import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipe_recorder_app/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class RecipeController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();
  
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> get recipes => _recipes;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  RecipeController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _storage.init();
    _setupConnectivityListener();
    await _loadInitialData();
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      final hasInternet = await InternetConnectionChecker().hasConnection;
      _isOnline = hasInternet;
      if (_isOnline) {
        syncData();
      }
      notifyListeners();
    });
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _storage.getRecipes();
      notifyListeners();

      final hasInternet = await InternetConnectionChecker().hasConnection;
      _isOnline = hasInternet;
      if (_isOnline) {
        await syncData();
      }
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncData() async {
    if (!_isOnline || _isSyncing) return;

    _isSyncing = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final offlineRecipes = _recipes.where((recipe) => recipe['isOffline'] == true).toList();
        
        for (var recipe in offlineRecipes) {
          final recipeData = Map<String, dynamic>.from(recipe);
          recipeData.remove('id');
          recipeData.remove('isOffline');
          
          final docRef = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .add(recipeData);
              
          recipe['id'] = docRef.id;
          recipe['isOffline'] = false;
        }

        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .get();
            
        final serverRecipes = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {...data, 'id': doc.id, 'isOffline': false};
        }).toList();
        
        final Map<String, Map<String, dynamic>> mergedRecipes = {};
        
        for (var recipe in serverRecipes) {
          mergedRecipes[recipe['id']] = recipe;
        }
        
        for (var recipe in _recipes) {
          if (!mergedRecipes.containsKey(recipe['id'])) {
            mergedRecipes[recipe['id']] = recipe;
          }
        }
        
        _recipes = mergedRecipes.values.toList();
        await _storage.saveRecipes(_recipes);
        notifyListeners();
      }
    } catch (e) {
      print('Error syncing data: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<bool> addRecipe(Map<String, dynamic> recipe) async {
    try {
      // Check for duplicates
      final existingRecipe = _recipes.firstWhere(
        (r) => r['title'].toLowerCase() == recipe['title'].toLowerCase(),
        orElse: () => {},
      );

      if (existingRecipe.isNotEmpty) {
        return false;
      }

      String? recipeId;
      
      if (_isOnline) {
        final user = _auth.currentUser;
        if (user != null) {
          final docRef = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .add(recipe);
          recipeId = docRef.id;
          recipe['isOffline'] = false;
        }
      } else {
        recipeId = _uuid.v4();
        recipe['isOffline'] = true;
      }
      
      if (recipeId != null) {
        recipe['id'] = recipeId;
        _recipes.insert(0, recipe);
        await _storage.saveRecipes(_recipes);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding recipe: $e');
      return false;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      if (_isOnline) {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .doc(id)
              .delete();
        }
      }
      
      _recipes.removeWhere((recipe) => recipe['id'] == id);
      await _storage.saveRecipes(_recipes);
      notifyListeners();
    } catch (e) {
      print('Error deleting recipe: $e');
    }
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      if (_isOnline) {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .doc(id)
              .update({'favorites': isFavorite});
        }
      }
      
      final index = _recipes.indexWhere((recipe) => recipe['id'] == id);
      if (index != -1) {
        _recipes[index]['favorites'] = isFavorite;
        await _storage.saveRecipes(_recipes);
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}
