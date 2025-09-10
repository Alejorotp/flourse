import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';

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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final code = _codeController.text.trim();
                  if (code.isNotEmpty) {
                    final userId = auth.currentUser.value.id ?? 0;
                    final success = await courseCon.joinCourse(
                      courseCode: code,
                      userId: userId,
                    );
                    if (success) {
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Curso no existente o ya eres miembro'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El código no puede estar vacío'),
                      ),
                    );
                  }
                },
                child: const Text("Unirse"),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () => FutureBuilder(
                  future: courseCon.getAllCourses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      final courses = snapshot.data!;
                      if (courses.isEmpty) {
                        return const Center(
                          child: Text('No hay cursos disponibles.'),
                        );
                      }
                      return ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CourseCard(courseInfo: course),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No hay cursos disponibles.'),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}