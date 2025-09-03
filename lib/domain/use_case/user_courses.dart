import 'dart:math';
import 'package:flourse/domain/models/course.dart';
import 'package:flourse/data/data.dart';
import 'package:flourse/domain/models/course_info.dart';

// map de ejemplo usurios regitrados (borrar más adelante)
final Map<String, String> userNames = {
  "1": "Manuel",
  "2": "Ana",
  "3": "Gaco",
  "4": "none",
};

List<UserCourseInfo> getUserCoursesInfo(List<Course> allCourses, String userId) {
  return allCourses.where((course) =>
    course.memberIds.contains(userId) || course.professorID == userId
  ).map((course) {
    final userRole = course.professorID == userId ? "Profesor" : "Miembro";
    final professorName = userNames[course.professorID] ?? "Desconocido";
    final memberNames = course.memberIds.map((id) => userNames[id] ?? "Desconocido").toList();

    return UserCourseInfo(
      course: course,
      userRole: userRole,
      professorName: professorName,
      memberNames: memberNames,
    );
  }).toList();
}

class CreateCourse {
  String _generateCourseCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  void createCourse({
    required String title,
    required String professorID,
  }) {
    final code = _generateCourseCode();
    final newCourse = Course(
      title: title,
      courseCode: code,
      professorID: professorID,
      memberIds: [],
      categories: [],
    );
    myCourses.add(newCourse);
  }
}