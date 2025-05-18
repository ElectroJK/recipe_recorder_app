import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recipe_recorder_app/aboutUs/aboutus.dart';
import 'package:recipe_recorder_app/homePage/FavoritesPage.dart';
import 'package:recipe_recorder_app/homePage/ProfilePage.dart';
import 'package:recipe_recorder_app/homePage/SettingsPage.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';
import 'package:recipe_recorder_app/design/theme.dart';
import 'package:recipe_recorder_app/models/recipe.dart';
import 'package:recipe_recorder_app/userData/UserSettingProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(Locale) onLocaleChanged;
  final ThemeMode currentTheme;
  final bool isGuest;

  const HomePage({
    Key? key,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.currentTheme,
    this.isGuest = false,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Set<String> favoriteRecipeIds = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .where('favorites', isEqualTo: true)
            .get();

    setState(() {
      favoriteRecipeIds = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = context.read<UserSettingsProvider>();
    final isDarkMode = userSettings.themeMode == ThemeMode.dark;
    final gradient = isDarkMode ? getDarkGradient() : getLightGradient();
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text(context.l10n.userNotLoggedIn)));
    }

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
                        (_) => AboutPage(currentTheme: userSettings.themeMode),
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
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('users')
                        .doc(user.uid)
                        .collection('recipes')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(context.l10n.errorLoadingRecipes),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  final recipeCards =
                      docs.map((doc) {
                        final data = doc.data()! as Map<String, dynamic>;
                        final recipeId = doc.id;
                        final title = data['title'] ?? '';
                        final description = data['description'] ?? '';
                        final image = data['image'] ?? '';
                        final isFavorite = data['favorites'] ?? false;

                        if (isFavorite) {
                          favoriteRecipeIds.add(recipeId);
                        } else {
                          favoriteRecipeIds.remove(recipeId);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Slidable(
                            key: ValueKey(recipeId),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed:
                                      (_) => _toggleFavorite(recipeId, title),
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  icon: Icons.star,
                                  label: context.l10n.favoritesLabel,
                                ),
                                SlidableAction(
                                  onPressed: (_) => _confirmDelete(recipeId),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: context.l10n.delete,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                _recipeCard(context, title, description, image),
                                if (isFavorite)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList();

                  return ListView(children: recipeCards);
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
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
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
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: context.l10n.profilePageTitle,
            ),
          ],
          onTap: (index) async {
            if (_selectedIndex == index) return;
            setState(() => _selectedIndex = index);

            if (index == 1) {
              final favorites = await _fetchFavoriteRecipes(user.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(favoriteRecipes: favorites),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => SettingsPage(
                        currentTheme: userSettings.themeMode,
                        onThemeChanged: widget.onThemeChanged,
                        onLocaleChanged: widget.onLocaleChanged,
                      ),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Recipe>> _fetchFavoriteRecipes(String userId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('recipes')
            .where('favorites', isEqualTo: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data()! as Map<String, dynamic>;
      return Recipe(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        image: data['image'] ?? '',
        favorites: true,
      );
    }).toList();
  }

  void _showAddRecipeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
                onPressed: () async {
                  final user = _auth.currentUser;
                  if (user == null) return;

                  if (titleController.text.isNotEmpty) {
                    final themeString =
                        widget.currentTheme == ThemeMode.dark
                            ? 'dark'
                            : (widget.currentTheme == ThemeMode.light
                                ? 'light'
                                : 'system');

                    final locale = Localizations.localeOf(context);
                    final localeString =
                        '${locale.languageCode}_${locale.countryCode ?? ''}';

                    await _firestore
                        .collection('users')
                        .doc(user.uid)
                        .collection('recipes')
                        .add({
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'image': imageController.text,
                          'favorites': false,
                        });
                  }
                  Navigator.pop(context);
                },
                child: Text(context.l10n.add),
              ),
            ],
          ),
    );
  }

  Future<void> _confirmDelete(String recipeId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
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
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .delete();

      setState(() {
        favoriteRecipeIds.remove(recipeId);
      });
    }
  }

  void _toggleFavorite(String recipeId, String title) {
    final user = _auth.currentUser;
    if (user == null) return;

    final isNowFavorite = !favoriteRecipeIds.contains(recipeId);

    setState(() {
      if (isNowFavorite) {
        favoriteRecipeIds.add(recipeId);
      } else {
        favoriteRecipeIds.remove(recipeId);
      }
    });

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({'favorites': isNowFavorite});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowFavorite
              ? context.l10n.recipeAddedToFavorites(title)
              : context.l10n.recipeRemovedFromFavorites(title),
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
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return SizedBox(
                  height: 180,
                  child: Center(
                    child: CircularProgressIndicator(
                      value:
                          progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                    ),
                  ),
                );
              },
              errorBuilder:
                  (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.food_bank, size: 40),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
