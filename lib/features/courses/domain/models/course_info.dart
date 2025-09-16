import 'package:flourse/features/courses/domain/models/course.dart';

class UserCourseInfo {
  final Course course;
  final String userRole;
  final String professorName;
  final List<String> memberNames;

  UserCourseInfo({
    required this.course,
    required this.userRole,
    required this.professorName,
    required this.memberNames,
  });
}
