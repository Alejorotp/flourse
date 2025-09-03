import 'package:flutter/material.dart';
import 'package:flourse/domain/models/course_info.dart';

class CurrentCoursePage extends StatelessWidget {
  static const String id = '/course-detail';
  final UserCourseInfo courseInfo;

  const CurrentCoursePage({super.key, required this.courseInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseInfo.course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Código del curso: ${courseInfo.course.courseCode}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Profesor: ${courseInfo.professorName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Total de miembros: ${courseInfo.memberNames.length}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Lista de estudiantes:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...courseInfo.memberNames.map((name) => Text('- $name')),
          ],
        ),
      ),
    );
  }
}