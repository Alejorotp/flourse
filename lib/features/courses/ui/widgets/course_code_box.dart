import 'package:flutter/material.dart';

class CourseCodeBox extends StatelessWidget {
  final String courseCode;
  const CourseCodeBox({super.key, required this.courseCode});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Código del curso",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                courseCode,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              const Text(
                "Comparte este código con tus estudiantes",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
