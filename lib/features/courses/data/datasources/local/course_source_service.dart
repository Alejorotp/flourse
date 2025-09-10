import 'dart:math';

import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../../../../data/data.dart';
import '../../../domain/models/course.dart';
import '../../../domain/models/course_info.dart';
import 'i_course_source.dart';

class CourseSourceService implements ICourseSource {
  final http.Client httpClient;

  CourseSourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<String> getUserNameById(int userId) async {
    logInfo("Fetching user name for userId: $userId");
    final user = fakeUsers[userId];
    if (user != null) {
      return Future.value(user.name);
    } else {
      return Future.value("Usuario Desconocido");
    }
  }

  @override
  Future<List<UserCourseInfo>> getCourseInfo(int userId) async {
    logInfo("Fetching course info for all courses related to userId: $userId");
    final courses = myCourses
        .where(
          (course) =>
              course.memberIDs.contains(userId) || course.professorID == userId,
        )
        .map((course) async {
          final userRole = course.professorID == userId
              ? "Profesor"
              : "Miembro";
          final professorName = getUserNameById(course.professorID);
          final memberNamesFutures = course.memberIDs
              .map((id) => getUserNameById(id))
              .toList();
          final memberNames = await Future.wait(memberNamesFutures);

          return UserCourseInfo(
            course: course,
            userRole: userRole,
            professorName: await professorName,
            memberNames: memberNames,
          );
        })
        .toList();
    return Future.wait(courses);
    }

  @override
  Future<List<Course>> getAllCourses() async {
    logInfo("Fetching all courses");
    return Future.value(myCourses);
  }

  @override
  Future<void> createCourse({
    required String title,
    required int professorID,
  }) async {
    logInfo("Creating course with title: $title for professorID: $professorID");

    String generateCourseCode() {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final rand = Random();
      return List.generate(
        6,
        (index) => chars[rand.nextInt(chars.length)],
      ).join();
    }

    final code = generateCourseCode();
    final newCourse = Course(
      title: title,
      courseCode: code,
      professorID: professorID,
      memberIDs: [],
      categoryIDs: [],
    );

    myCourses.add(newCourse);
    return Future.value();
  }
}
