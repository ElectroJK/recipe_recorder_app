import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/logics/logic.dart';
import 'package:recipe_recorder_app/aboutUs/aboutus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Recorder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                isPortrait
                    ? ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          title: recipes[index]['title']!,
                          description: recipes[index]['description']!,
                          imageUrl: recipes[index]['image']!,
                        );
                      },
                    )
                    : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 800 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          title: recipes[index]['title']!,
                          description: recipes[index]['description']!,
                          imageUrl: recipes[index]['image']!,
                        );
                      },
                    ),
          );
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
