import 'package:flutter/material.dart';
import 'package:flourse/domain/models/course.dart';

class CurrentCoursePage extends StatelessWidget {
  static const String id = '/course-detail';
  final Course course;

  const CurrentCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Role: ${course.role}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Members: ${course.members}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Members IDs:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Muestra la lista de IDs de miembros
            ...course.memberIds.map((id) => Text('- $id')).toList(),
            // Aquí podrías añadir más información del curso
          ],
        ),
      ),
    );
  }
}