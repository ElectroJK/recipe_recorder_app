import 'package:flutter/material.dart';
import 'homePage/home_page.dart';
import 'aboutUs/aboutus.dart';
import 'design/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Recorder',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
