import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About us")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Recipe recorder app",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Recipe Recorder App is designed to help users save and manage their favorite recipes efficiently. "
              "With an integrated database, users can store their recipes in a structured format, ensuring they never lose important details. "
              "The app also provides cooking tips and suggestions to enhance the user’s culinary skills.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Developers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Developed by:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            const Text(
              "Tanatkanov Kadyrulan\nAsanali Ashimov\nZholaman Yerzhan",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Course: Crossplatform Development, Astana IT University",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 5),
            const Text(
              "Mentor: Assistant Professor Abzal Kyzyrkanov",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
