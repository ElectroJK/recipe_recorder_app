import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';

class GuestRecipeCatalogPage extends StatefulWidget {
  const GuestRecipeCatalogPage({Key? key}) : super(key: key);

  @override
  State<GuestRecipeCatalogPage> createState() => _GuestRecipeCatalogPageState();
}

class _GuestRecipeCatalogPageState extends State<GuestRecipeCatalogPage> {
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _recipes = data['meals'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load recipes';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _showRecipeDetails(Map<String, dynamic> recipe) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (recipe['strMealThumb'] != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: Image.network(
                                recipe['strMealThumb'],
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['strMeal'] ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (recipe['strCategory'] != null || recipe['strArea'] != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (recipe['strCategory'] != null)
                                    Chip(
                                      label: Text(recipe['strCategory']),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF1A2C25)
                                          : const Color(0xFFF2F7F4),
                                    ),
                                  if (recipe['strArea'] != null)
                                    Chip(
                                      label: Text(recipe['strArea']),
                                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? const Color(0xFF1A2C25)
                                          : const Color(0xFFF2F7F4),
                                    ),
                                ],
                              ),
                            const SizedBox(height: 24),
                            Text(
                              'Ingredients',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildIngredientsList(recipe),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Instructions',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe['strInstructions'] ?? '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList(Map<String, dynamic> recipe) {
    List<Widget> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = recipe['strIngredient$i'];
      final measure = recipe['strMeasure$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '• $measure $ingredient',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.recipeCatalogTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : RefreshIndicator(
                  onRefresh: _fetchRecipes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () => _showRecipeDetails(recipe),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  recipe['strMealThumb'] ?? '',
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 200,
                                    color: isDark
                                        ? const Color(0xFF1A2C25)
                                        : const Color(0xFFF2F7F4),
                                    child: Icon(
                                      Icons.broken_image_rounded,
                                      size: 40,
                                      color: isDark
                                          ? const Color(0xFF3D9F6F)
                                          : const Color(0xFF2C7A52),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe['strMeal'] ?? '',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (recipe['strCategory'] != null ||
                                        recipe['strArea'] != null)
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          if (recipe['strCategory'] != null)
                                            Chip(
                                              label: Text(recipe['strCategory']),
                                              backgroundColor: isDark
                                                  ? const Color(0xFF1A2C25)
                                                  : const Color(0xFFF2F7F4),
                                            ),
                                          if (recipe['strArea'] != null)
                                            Chip(
                                              label: Text(recipe['strArea']),
                                              backgroundColor: isDark
                                                  ? const Color(0xFF1A2C25)
                                                  : const Color(0xFFF2F7F4),
                                            ),
                                        ],
                                      ),
                                    const SizedBox(height: 16),
                                    Text(
                                      recipe['strInstructions'] ?? '',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () => _showRecipeDetails(recipe),
                                      child: Text(context.l10n.viewRecipeDetails),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
} 