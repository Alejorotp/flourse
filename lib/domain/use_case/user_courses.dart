import 'package:flourse/domain/models/course.dart';

List<Course> getUserCourses(List<Course> allCourses, String userId) {
  return allCourses.where((course) =>
    course.memberIds.contains(userId) || course.professorID == userId
  ).toList();
}