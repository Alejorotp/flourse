// lib/widgets/course_card.dart

import 'package:flutter/material.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';
import 'package:flourse/features/courses/ui/pages/currentCourse.dart';
import 'package:loggy/loggy.dart';

class CourseCard extends StatelessWidget {
  final UserCourseInfo courseInfo;

  const CourseCard({super.key, required this.courseInfo});

  @override
  Widget build(BuildContext context) {
    //Loggy(courseInfo.userRole);
    final isProfessor = courseInfo.userRole.toLowerCase() != 'miembro';
    final borderColor = isProfessor ? Colors.red.shade200 : Colors.grey.shade300;
    final backgroundColor = isProfessor ? Colors.red.shade50 : Colors.grey.shade200;

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
          color: backgroundColor,
          border: Border.all(color: borderColor),
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
