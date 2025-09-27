import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

class JoinCoursePage extends StatelessWidget {
  static const String id = '/join-course';

  const JoinCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();
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
              "Unirse a un curso",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Código del curso",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "The course code is provided by the professor.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final code = _codeController.text.trim();
                  if (code.isNotEmpty) {
                    final userId = auth.currentUser.value.id ?? "0";
                    final success = await courseCon.joinCourse(
                      courseCode: code,
                      userId: userId,
                    );
                    if (success) {
                      Get.snackbar(
                        "Éxito",
                        "Te has unido al curso éxitosamente",
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        "Error",
                        "Curso no existente o ya eres miembro",
                        icon: const Icon(Icons.error, color: Colors.red),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Error",
                      "El código no puede estar vacío",
                      icon: const Icon(Icons.error, color: Colors.red),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text("Unirse"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}