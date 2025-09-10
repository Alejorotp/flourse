import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/domain/use_case/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/user_courses.dart';

class CreateCoursePage extends StatelessWidget {
  static const String id = '/create-course';

  const CreateCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final userCoursesUseCase = CreateCourse();

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
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    final auth = Get.find<AuthController>();
                    final userId = auth.currentUser.value?.id?.toString() ?? '';
                    userCoursesUseCase.createCourse(
                      title: name,
                      professorID: userId,
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El nombre no puede estar vacío'),
                      ),
                    );
                  }
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
