import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

class CreateCoursePage extends StatelessWidget {
  static const String id = '/create-course';

  const CreateCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    CoursesController courseCon = Get.find();
    AuthenticationController auth = Get.find();

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
                onPressed: () async {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    final userId = auth.currentUser.value.id?.toString() ?? '';
                    final created = await courseCon.createCourse(
                      title: name,
                      professorID: userId,
                    );
                    if (created) {
                      Get.snackbar(
                        "Éxito",
                        "Curso creado éxitosamente",
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        "Error",
                        "No puedes ser profesor de más de 3 cursos",
                        icon: const Icon(Icons.error, color: Colors.red),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Navigator.of(context).pop();
                    }
                  } else {
                      Get.snackbar(
                        "Error",
                        "El nombre no puede estar vacío",
                        icon: const Icon(Icons.error, color: Colors.red),
                        snackPosition: SnackPosition.BOTTOM,
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