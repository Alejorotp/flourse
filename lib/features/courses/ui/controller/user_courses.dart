import 'dart:math';
import 'package:flourse/features/courses/domain/models/course.dart';
import 'package:flourse/data/data.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';

String getUserNameById(int id) {
  final user = fakeUsers.values.firstWhere(
    (user) => user.id == id
  );
  return user.name;
}

List<UserCourseInfo> getUserCoursesInfo(
  List<Course> allCourses,
  String userId,
) {
  return allCourses
      .where(
        (course) =>
            course.memberIDs.contains(int.parse(userId)) || course.professorID == int.parse(userId),
      )
      .map((course) {
        final userRole = course.professorID == int.parse(userId) ? "Profesor" : "Miembro";
        final professorName = getUserNameById(course.professorID);
        final memberNames = course.memberIDs
            .map((id) => getUserNameById(id))
            .toList();

        return UserCourseInfo(
          course: course,
          userRole: userRole,
          professorName: professorName,
          memberNames: memberNames,
        );
      })
      .toList();
}

class CreateCourse {
  String _generateCourseCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(
      6,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  void createCourse({required String title, required int professorID}) {
    final code = _generateCourseCode();
    final newCourse = Course(
      title: title,
      courseCode: code,
      professorID: professorID,
      memberIDs: [],
      categoryIDs: [],
    );
    myCourses.add(newCourse);
  }
}

void joinCourse({required String courseCode, required int userId}) {
  final course = myCourses.firstWhere(
    (course) => course.courseCode == courseCode,
    orElse: () => throw Exception("Course with code $courseCode not found"),
  );

  if (course.memberIDs.contains(userId)) {
    throw Exception("User with ID $userId is already a member of the course");
  }

  course.memberIDs.add(userId);
}