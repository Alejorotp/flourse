import 'package:flutter/material.dart';

class CreateCoursePage extends StatelessWidget {
  static const String id = '/create-course';

  const CreateCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flourse"),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.settings),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Crear nuevo curso",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del curso",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí irá la funcionalidad para crear el curso
                },
                child: const Text("Crear"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}