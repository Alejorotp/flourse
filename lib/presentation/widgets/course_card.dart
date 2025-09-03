// lib/widgets/course_card.dart

import 'package:flutter/material.dart';
import 'package:flourse/domain/models/course.dart';
import 'package:flourse/presentation/pages/currentcourse.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentCoursePage(course: course),
          ),
        );
      },
      child: Container(
        width: 160, // tamaño de los cards
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(course.professorID),
            Text('${course.members} Members'),
            const SizedBox(height: 8),
            Row(
              children: const [
                CircleAvatar(radius: 12),
                SizedBox(width: 4),
                CircleAvatar(radius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}