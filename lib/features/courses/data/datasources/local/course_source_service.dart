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
  Future<UserCourseInfo> getCourseInfo(String courseCode, String userId) async {
    logInfo(
      "Fetching course info for courseCode: $courseCode and userId: $userId",
    );
    final course = myCourses.firstWhere(
      (course) => course.courseCode == courseCode,
      orElse: () => Course(
        title: 'Unknown',
        professorID: -1,
        courseCode: 'N/A',
        memberIDs: [],
        categoryIDs: [],
      ),
    );
    final userRole = course.professorID.toString() == userId
        ? "Profesor"
        : (course.memberIDs.contains(int.parse(userId))
              ? "Miembro"
              : "No inscrito");
    return Future.value(
      UserCourseInfo(
        course: course,
        userRole: userRole,
        professorName: "Profesor X",
        memberNames: [],
      ),
    );
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
