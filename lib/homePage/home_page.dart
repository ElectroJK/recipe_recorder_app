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
import 'package:recipe_recorder_app/models/recipe_controller.dart';
import 'package:recipe_recorder_app/userData/login_page.dart';

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
  final List<Widget> _pages = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _checkAuthState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _checkAuthState() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => LoginPage(
                  currentTheme: widget.currentTheme,
                  onThemeChanged: widget.onThemeChanged,
                  onLocaleChanged: widget.onLocaleChanged,
                ),
          ),
          (route) => false,
        );
      }
    });
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

  void _onNavBarTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      _navigateToFavorites();
    } else if (index == 2) {
      _navigateToSettings();
    } else if (index == 3) {
      _navigateToProfile();
    }
  }

  Future<void> _navigateToFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favorites = await _fetchFavoriteRecipes(user.uid);
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesPage(favoriteRecipes: favorites),
      ),
    );
    setState(() => _selectedIndex = 0);
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SettingsPage(
              currentTheme: widget.currentTheme,
              onThemeChanged: widget.onThemeChanged,
              onLocaleChanged: widget.onLocaleChanged,
            ),
      ),
    ).then((_) => setState(() => _selectedIndex = 0));
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    ).then((_) => setState(() => _selectedIndex = 0));
  }

  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userSettings = context.read<UserSettingsProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: context.l10n.searchHint,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              setState(() => _searchQuery = _searchController.text);
              FocusScope.of(context).unfocus();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(context.l10n.searchButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = context.read<UserSettingsProvider>();
    final isDarkMode = userSettings.themeMode == ThemeMode.dark;
    final gradient = isDarkMode ? getDarkGradient() : getLightGradient();
    final user = _auth.currentUser;
    final recipeController = Provider.of<RecipeController>(context);

    if (user == null) {
      return Scaffold(body: Center(child: Text(context.l10n.userNotLoggedIn)));
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  context.l10n.appTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildConnectionIndicator(recipeController),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          actions: [
            if (!recipeController.isSyncing)
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed:
                    recipeController.isOnline
                        ? () => recipeController.syncData()
                        : null,
                tooltip:
                    recipeController.isOnline
                        ? 'Sync data'
                        : 'Offline - Cannot sync',
              ),
            if (recipeController.isSyncing)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
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
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!.docs;
                        final filteredDocs =
                            _searchQuery.isEmpty
                                ? docs
                                : docs.where((doc) {
                                  final data =
                                      doc.data()! as Map<String, dynamic>;
                                  final title =
                                      (data['title'] as String? ?? '')
                                          .toLowerCase();
                                  final description =
                                      (data['description'] as String? ?? '')
                                          .toLowerCase();
                                  final query = _searchQuery.toLowerCase();
                                  return title.contains(query) ||
                                      description.contains(query);
                                }).toList();

                        if (filteredDocs.isEmpty) {
                          return Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? 'No recipes yet. Add some!'
                                  : context.l10n.noSearchResults,
                            ),
                          );
                        }

                        final recipeCards =
                            filteredDocs.map((doc) {
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
                                            (_) => _toggleFavorite(
                                              recipeId,
                                              title,
                                            ),
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        icon: Icons.star,
                                        label: context.l10n.favoritesLabel,
                                      ),
                                      SlidableAction(
                                        onPressed:
                                            (_) => _confirmDelete(recipeId),
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
                                        title,
                                        description,
                                        image,
                                      ),
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
              ],
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
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
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
          onTap: _onNavBarTap,
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
    bool isAdding = false;

    showDialog(
      context: context,
      barrierDismissible: !isAdding,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(context.l10n.addRecipe),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        enabled: !isAdding,
                        decoration: InputDecoration(
                          labelText: context.l10n.titleLabel,
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        enabled: !isAdding,
                        decoration: InputDecoration(
                          labelText: context.l10n.descriptionLabel,
                        ),
                      ),
                      TextField(
                        controller: imageController,
                        enabled: !isAdding,
                        decoration: InputDecoration(
                          labelText: context.l10n.imageLabel,
                        ),
                      ),
                      if (isAdding)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: isAdding ? null : () => Navigator.pop(context),
                      child: Text(context.l10n.cancel),
                    ),
                    TextButton(
                      onPressed:
                          isAdding
                              ? null
                              : () async {
                                final user = _auth.currentUser;
                                if (user == null) return;

                                if (titleController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(context.l10n.titleRequired),
                                    ),
                                  );
                                  return;
                                }

                                setState(() => isAdding = true);

                                final recipeController =
                                    Provider.of<RecipeController>(
                                      context,
                                      listen: false,
                                    );

                                final success = await recipeController
                                    .addRecipe({
                                      'title': titleController.text,
                                      'description': descriptionController.text,
                                      'image': imageController.text,
                                      'favorites': false,
                                    });

                                if (success) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        recipeController.isOnline
                                            ? context.l10n.recipeAddedOnline
                                            : context.l10n.recipeAddedOffline,
                                      ),
                                    ),
                                  );
                                } else {
                                  setState(() => isAdding = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.l10n.errorAddingRecipe,
                                      ),
                                    ),
                                  );
                                }
                              },
                      child: Text(context.l10n.add),
                    ),
                  ],
                ),
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
    final bool validImageUrl =
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

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
            child:
                validImageUrl
                    ? Image.network(
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
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                    )
                    : Container(
                      height: 180,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, size: 40),
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

  Widget _buildConnectionIndicator(RecipeController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            controller.isOnline
                ? Colors.green.withOpacity(0.8)
                : Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.isOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            controller.isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}