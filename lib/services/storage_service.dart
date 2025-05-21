import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_recorder_app/models/recipe.dart';

class StorageService {
  static const String recipesBoxName = 'recipes';
  static const String userBoxName = 'user';
  
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(recipesBoxName);
    await Hive.openBox(userBoxName);
  }

  Future<void> saveRecipes(List<Map<String, dynamic>> recipes) async {
    final box = Hive.box<Map>(recipesBoxName);
    await box.clear();
    for (var recipe in recipes) {
      await box.add(Map<String, dynamic>.from(recipe));
    }
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    final box = Hive.box<Map>(recipesBoxName);
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> saveUserCredentials(String email, String uid) async {
    final box = Hive.box(userBoxName);
    await box.put('email', email);
    await box.put('uid', uid);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final box = Hive.box(userBoxName);
    return {
      'email': box.get('email'),
      'uid': box.get('uid'),
    };
  }

  Future<void> clearUserCredentials() async {
    final box = Hive.box(userBoxName);
    await box.clear();
  }
} 