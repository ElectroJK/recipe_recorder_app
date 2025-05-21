import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_recorder_app/homePage/home_page.dart';
import 'package:recipe_recorder_app/userData/register_page.dart';
import 'package:recipe_recorder_app/homePage/GuestHomePage.dart';
import 'package:recipe_recorder_app/services/storage_service.dart';

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
  final StorageService _storage = StorageService();
  bool obscureText = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    final user = FirebaseAuth.instance.currentUser;
    final credentials = await _storage.getUserCredentials();

    if (user != null) {
 
      if (user.isAnonymous) {
        await FirebaseAuth.instance.signOut();
        await _storage.clearUserCredentials();
        return;
      }
      
 
      if (!user.isAnonymous && credentials != null && credentials['email'] != null) {
        _navigateToHome();
      } else {

        await FirebaseAuth.instance.signOut();
        await _storage.clearUserCredentials();
      }
    }
  }

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (userCredential.user != null) {
        await _storage.saveUserCredentials(
          emailController.text.trim(),
          userCredential.user!.uid,
        );
      }
      
      _navigateToHome();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message ?? e.code}')),
      );
    } finally {
      setState(() => isLoading = false);
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
    setState(() => isLoading = true);
    try {
      // Clear any existing auth state and storage
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      await _storage.clearUserCredentials();
      
      if (!mounted) return;
      
      // Navigate to guest page without Firebase authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuestHomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Guest login failed: $e')));
    } finally {
      setState(() => isLoading = false);
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
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed:
                            () => setState(() => obscureText = !obscureText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: isLoading ? null : _goToRegister,
                    child: const Text("Don't have an account? Register"),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _loginAsGuest,
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Continue as guest'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
