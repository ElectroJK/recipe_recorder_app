import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_recorder_app/homePage/home_page.dart';
import 'package:recipe_recorder_app/userData/register_page.dart';
import 'package:recipe_recorder_app/homePage/GuestHomePage.dart';

class LoginPage extends StatefulWidget {
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;

  const LoginPage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      _navigateToHome();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomePage(
              currentTheme: widget.currentTheme,
              onThemeChanged: widget.onThemeChanged,
              onLocaleChanged: widget.onLocaleChanged,
            ),
      ),
    );
  }

  void _loginAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuestHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Guest login failed: $e')));
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RegisterPage(
              currentTheme: widget.currentTheme,
              onThemeChanged: widget.onThemeChanged,
              onLocaleChanged: widget.onLocaleChanged,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => obscureText = !obscureText),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _goToRegister,
              child: const Text("Don't have an account? Register"),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _loginAsGuest,
              icon: const Icon(Icons.person_outline),
              label: const Text('Continue as guest'),
            ),
          ],
        ),
      ),
    );
  }
}
