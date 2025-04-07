import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AboutCard(
                title: "About Recipe Recorder App",
                content:
                    "Recipe Recorder App helps users efficiently save and manage their favorite recipes. "
                    "With an integrated database, users can securely store and access recipes anytime. "
                    "The app also provides cooking tips and suggestions to enhance your culinary skills.",
              ),
              const SizedBox(height: 20),
              AboutCard(
                title: "Developers",
                content:
                    "Developed by:\n\nTanatkanov Kadyrulan\nAsanali Ashimov\nZholaman Yerzhan",
              ),
              const SizedBox(height: 20),
              AboutCard(
                title: "Course Details",
                content:
                    "Course: Crossplatform Development, Astana IT University\n"
                    "Mentor: Assistant Professor Abzal Kyzyrkanov",
                isItalic: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutCard extends StatelessWidget {
  final String title;
  final String content;
  final bool isItalic;

  const AboutCard({
    super.key,
    required this.title,
    required this.content,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
