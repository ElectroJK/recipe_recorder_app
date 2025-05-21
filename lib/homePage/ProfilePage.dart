import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_recorder_app/services/storage_service.dart';
import 'package:recipe_recorder_app/userData/login_page.dart';
import 'package:recipe_recorder_app/l10n/app_localizations_ext.dart';
import 'package:provider/provider.dart';
import 'package:recipe_recorder_app/userData/UserSettingProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Color> _avatarColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  int _currentColorIndex = 0;
  String _username = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            _currentColorIndex = data['avatarColorIndex'] ?? 0;
            _username = user.displayName ?? user.email?.split('@')[0] ?? 'User';
          });
        }
      } else {
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName ?? user.email?.split('@')[0] ?? 'User',
          'avatarColorIndex': 0,
          'email': user.email,
        });
        setState(() {
          _username = user.displayName ?? user.email?.split('@')[0] ?? 'User';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'avatarColorIndex': _currentColorIndex,
      });
    }
  }

  void _changeAvatarColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _avatarColors.length;
    });
    _updateProfile();
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.logoutConfirmTitle),
            content: Text(context.l10n.logoutConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.no),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.yes),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await _showLogoutConfirmation(context);
    if (!shouldLogout) return;

    try {
      final storageService = StorageService();
      await storageService.clearUserCredentials();
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        final userSettings = Provider.of<UserSettingsProvider>(
          context,
          listen: false,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => LoginPage(
                  currentTheme: userSettings.themeMode,
                  onThemeChanged: userSettings.setThemeMode,
                  onLocaleChanged: userSettings.setLocale,
                ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _changeAvatarColor,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _avatarColors[_currentColorIndex],
                    child: Text(
                      _username.isNotEmpty ? _username[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.white70 : Colors.black12,
                        ),
                      ),
                      child: Icon(
                        Icons.color_lens,
                        size: 20,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(user.email ?? 'No email'),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.l10n.logout),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
