import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_recorder_app/userData/login_page.dart';

class GuestHomePage extends StatefulWidget {
  final bool guestMode;

  const GuestHomePage({Key? key, this.guestMode = true}) : super(key: key);

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
    } else if (index == 1) {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (_) => LoginPage(
                currentTheme: ThemeMode.light,
                onThemeChanged: (_) {},
                onLocaleChanged: (_) {},
              ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(child: Text('Guest Home Page', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Guest Mode')),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Exit'),
        ],
      ),
    );
  }
}
