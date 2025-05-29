import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recipe_recorder_app/aboutUs/aboutus.dart';
import 'package:recipe_recorder_app/homePage/FavoritesPage.dart';
import 'package:recipe_recorder_app/homePage/ProfilePage.dart';
import 'package:recipe_recorder_app/homePage/SettingsPage.dart';
import 'package:recipe_recorder_app/homePage/RecipeCatalogPage.dart';
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
      _navigateToRecipeCatalog();
    } else if (index == 3) {
      _navigateToSettings();
    } else if (index == 4) {
      _navigateToProfile();
    }
  }

  void _navigateToFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    final favorites = _fetchFavoriteRecipes(user.uid);
    if (!mounted) return;

    favorites.then((favorites) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FavoritesPage(favoriteRecipes: favorites),
        ),
      );
      setState(() => _selectedIndex = 0);
    });
  }

  void _navigateToRecipeCatalog() {
    final recipeController = Provider.of<RecipeController>(context, listen: false);
    if (!recipeController.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.catalogOfflineError,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() => _selectedIndex = 0);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeCatalogPage()),
    ).then((_) => setState(() => _selectedIndex = 0));
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
                                ? context.l10n.noRecipesFound
                                : context.l10n.noSearchResults,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                              textAlign: TextAlign.center,
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
                                    extentRatio: 0.25,
                                    dragDismissible: false,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: const BorderRadius.horizontal(
                                                right: Radius.circular(16),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CustomSlidableAction(
                                                    onPressed: (_) => _toggleFavorite(recipeId, title),
                                                    backgroundColor: Colors.transparent,
                                                    foregroundColor: const Color(0xFFFFB74D),
                                                    autoClose: true,
                                                    padding: EdgeInsets.zero,
                                                    child: Container(
                                                      margin: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? const Color(0xFF1A2C25)
                                                            : Colors.white,
                                                        borderRadius: const BorderRadius.only(
                                                          topRight: Radius.circular(14),
                                                          bottomRight: Radius.circular(14),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.star_rounded,
                                                        size: 26,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.white.withOpacity(0.05)
                                                      : Colors.black.withOpacity(0.05),
                                                ),
                                                Expanded(
                                                  child: CustomSlidableAction(
                                                    onPressed: (_) => _showEditDialog(recipeId, data),
                                                    backgroundColor: Colors.transparent,
                                                    foregroundColor: const Color(0xFF4CAF50),
                                                    autoClose: true,
                                                    padding: EdgeInsets.zero,
                                                    child: Container(
                                                      margin: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? const Color(0xFF1A2C25)
                                                            : Colors.white,
                                                        borderRadius: const BorderRadius.only(
                                                          topRight: Radius.circular(14),
                                                          bottomRight: Radius.circular(14),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.edit_rounded,
                                                        size: 26,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.white.withOpacity(0.05)
                                                      : Colors.black.withOpacity(0.05),
                                                ),
                                                Expanded(
                                                  child: CustomSlidableAction(
                                                    onPressed: (_) => _confirmDelete(recipeId),
                                                    backgroundColor: Colors.transparent,
                                                    foregroundColor: const Color(0xFFEF5350),
                                                    autoClose: true,
                                                    padding: EdgeInsets.zero,
                                                    child: Container(
                                                      margin: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? const Color(0xFF1A2C25)
                                                            : Colors.white,
                                                        borderRadius: const BorderRadius.only(
                                                          topRight: Radius.circular(14),
                                                          bottomRight: Radius.circular(14),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete_rounded,
                                                        size: 26,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _showRecipeDetails(data),
                                    child: _buildRecipeCard(data),
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
              icon: const Icon(Icons.menu_book),
              label: context.l10n.bottomNavCatalog,
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
    final ingredientsController = TextEditingController();
    final categoryController = TextEditingController();
    final areaController = TextEditingController();
    bool isAdding = false;

    showDialog(
      context: context,
      barrierDismissible: !isAdding,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.addRecipe,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isAdding)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(
                          context,
                          controller: titleController,
                          label: context.l10n.titleLabel,
                          icon: Icons.restaurant_menu,
                          enabled: !isAdding,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: categoryController,
                          label: context.l10n.categoryLabel,
                          icon: Icons.category,
                          hint: context.l10n.categoryHint,
                          enabled: !isAdding,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: areaController,
                          label: context.l10n.areaLabel,
                          icon: Icons.public,
                          hint: context.l10n.areaHint,
                          enabled: !isAdding,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: ingredientsController,
                          label: context.l10n.ingredientsLabel,
                          icon: Icons.list_alt,
                          hint: context.l10n.ingredientsHint,
                          maxLines: 5,
                          enabled: !isAdding,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: descriptionController,
                          label: context.l10n.descriptionLabel,
                          icon: Icons.description,
                          maxLines: 3,
                          enabled: !isAdding,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: imageController,
                          label: context.l10n.imageLabel,
                          icon: Icons.image,
                          enabled: !isAdding,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (isAdding)
                  const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  )
                else
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.l10n.cancel,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final user = _auth.currentUser;
                          if (user == null) return;

                          if (titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(context.l10n.titleRequired)),
                            );
                            return;
                          }

                          setState(() => isAdding = true);

                          final recipeController = Provider.of<RecipeController>(
                            context,
                            listen: false,
                          );

                          final success = await recipeController.addRecipe({
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'image': imageController.text,
                            'ingredients': ingredientsController.text,
                            'category': categoryController.text,
                            'area': areaController.text,
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
                                content: Text(context.l10n.duplicateRecipeError),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.l10n.add),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A2C25)
            : const Color(0xFFF2F7F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF0F1F1A)
                : Colors.white,
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
                          if (recipe['image'] != null && recipe['image'].isNotEmpty)
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                child: Image.network(
                                  recipe['image'],
                                  width: double.infinity,
                                  height: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildPlaceholderImage(context),
                                ),
                              ),
                            )
                          else
                            _buildPlaceholderImage(context),
                          _buildCloseButton(context),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecipeHeader(context, recipe),
                            const SizedBox(height: 32),
                            if (recipe['category']?.isNotEmpty == true ||
                                recipe['area']?.isNotEmpty == true)
                              _buildRecipeMetadata(context, recipe),
                            if (recipe['ingredients']?.isNotEmpty == true)
                              _buildRecipeSection(
                                context,
                                title: context.l10n.ingredientsLabel,
                                icon: Icons.list_alt,
                                content: recipe['ingredients'],
                              ),
                            _buildRecipeSection(
                              context,
                              title: context.l10n.descriptionLabel,
                              icon: Icons.description_outlined,
                              content: recipe['description'] ?? '',
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

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A2C25)
            : const Color(0xFFF2F7F4),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF3D9F6F)
                : const Color(0xFF2C7A52),
          ),
          const SizedBox(height: 16),
          Text(
            'No Image Available',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF3D9F6F)
                  : const Color(0xFF2C7A52),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeHeader(BuildContext context, Map<String, dynamic> recipe) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            recipe['title'] ?? '',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF2C7A52),
              height: 1.2,
            ),
          ),
        ),
        if (recipe['favorites'] == true)
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A2C25)
                  : const Color(0xFFF2F7F4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
              ),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB74D),
              size: 28,
            ),
          ),
      ],
    );
  }

  Widget _buildRecipeMetadata(BuildContext context, Map<String, dynamic> recipe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (recipe['category']?.isNotEmpty == true)
            Chip(
              label: Text(recipe['category']),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A2C25)
                  : const Color(0xFFF2F7F4),
            ),
          if (recipe['area']?.isNotEmpty == true)
            Chip(
              label: Text(recipe['area']),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A2C25)
                  : const Color(0xFFF2F7F4),
            ),
        ],
      ),
    );
  }

  Widget _buildRecipeSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
  }) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A2C25)
            : const Color(0xFFF2F7F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3D9F6F)
                    : const Color(0xFF2C7A52),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF3D9F6F)
                      : const Color(0xFF2C7A52),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.black.withOpacity(0.8),
            ),
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

  void _showEditDialog(String recipeId, Map<String, dynamic> recipeData) {
    final titleController = TextEditingController(text: recipeData['title'] ?? '');
    final descriptionController = TextEditingController(text: recipeData['description'] ?? '');
    final imageController = TextEditingController(text: recipeData['image'] ?? '');
    final ingredientsController = TextEditingController(text: recipeData['ingredients'] ?? '');
    final categoryController = TextEditingController(text: recipeData['category'] ?? '');
    final areaController = TextEditingController(text: recipeData['area'] ?? '');
    bool isUpdating = false;

    showDialog(
      context: context,
      barrierDismissible: !isUpdating,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.editRecipeTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isUpdating)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(
                          context,
                          controller: titleController,
                          label: context.l10n.titleLabel,
                          icon: Icons.restaurant_menu,
                          enabled: !isUpdating,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: categoryController,
                          label: context.l10n.categoryLabel,
                          icon: Icons.category,
                          hint: context.l10n.categoryHint,
                          enabled: !isUpdating,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: areaController,
                          label: context.l10n.areaLabel,
                          icon: Icons.public,
                          hint: context.l10n.areaHint,
                          enabled: !isUpdating,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: ingredientsController,
                          label: context.l10n.ingredientsLabel,
                          icon: Icons.list_alt,
                          hint: context.l10n.ingredientsHint,
                          maxLines: 5,
                          enabled: !isUpdating,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: descriptionController,
                          label: context.l10n.descriptionLabel,
                          icon: Icons.description,
                          maxLines: 3,
                          enabled: !isUpdating,
                        ),
                        const SizedBox(height: 12),
                        _buildInputField(
                          context,
                          controller: imageController,
                          label: context.l10n.imageLabel,
                          icon: Icons.image,
                          enabled: !isUpdating,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (isUpdating)
                  const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  )
                else
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.l10n.cancel,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final user = _auth.currentUser;
                          if (user == null) return;

                          if (titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(context.l10n.titleRequired)),
                            );
                            return;
                          }

                          setState(() => isUpdating = true);

                          try {
                            await _firestore
                                .collection('users')
                                .doc(user.uid)
                                .collection('recipes')
                                .doc(recipeId)
                                .update({
                              'title': titleController.text,
                              'description': descriptionController.text,
                              'image': imageController.text.trim(),
                              'ingredients': ingredientsController.text,
                              'category': categoryController.text,
                              'area': areaController.text,
                            });

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.recipeUpdated),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() => isUpdating = false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.recipeUpdateFailed),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(context.l10n.saveChanges),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
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

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (recipe['image'] != null && recipe['image'].isNotEmpty)
                Image.network(
                  recipe['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1A2C25)
                          : const Color(0xFFF2F7F4),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1A2C25)
                        : const Color(0xFFF2F7F4),
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 40,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF3D9F6F)
                          : const Color(0xFF2C7A52),
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A2C25)
                      : const Color(0xFFF2F7F4),
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    size: 40,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF3D9F6F)
                        : const Color(0xFF2C7A52),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['title'] ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        height: 1.3,
                      ),
                    ),
                    if (recipe['category']?.isNotEmpty == true ||
                        recipe['area']?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (recipe['category']?.isNotEmpty == true)
                            Chip(
                              label: Text(
                                recipe['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.8),
                                ),
                              ),
                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF1A2C25)
                                  : const Color(0xFFF2F7F4),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          if (recipe['area']?.isNotEmpty == true)
                            Chip(
                              label: Text(
                                recipe['area'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.8),
                                ),
                              ),
                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF1A2C25)
                                  : const Color(0xFFF2F7F4),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      recipe['description'] ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (recipe['favorites'] == true)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB74D),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}