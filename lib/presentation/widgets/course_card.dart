// lib/widgets/course_card.dart

import 'package:flutter/material.dart';
import 'package:flourse/domain/models/course_info.dart';
import 'package:flourse/presentation/pages/currentcourse.dart';

class CourseCard extends StatelessWidget {
  final UserCourseInfo courseInfo;

  const CourseCard({
    super.key,
    required this.courseInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentCoursePage(courseInfo: courseInfo),
          ),
        );
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseInfo.course.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(courseInfo.userRole),
            Text('${courseInfo.memberNames.length} Estudiantes'),
          ],
        ),
      ),
    );
  }
}