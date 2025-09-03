import 'package:flourse/domain/models/course.dart';

class UserCourseInfo {
  final Course course;
  final List<String> memberNames;
  final String userRole; // "profesor" o "miembro"

  UserCourseInfo({
    required this.course,
    required this.memberNames,
    required this.userRole,
  });
}