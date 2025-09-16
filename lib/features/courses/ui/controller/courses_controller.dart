import 'package:get/get.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';

import 'package:loggy/loggy.dart';

import '../../domain/use_case/course_usecase.dart';

class CoursesController extends GetxController {
  final CourseUseCase coursation;
  CoursesController(this.coursation);

  var courses = <Course>[].obs;

  Future<List<UserCourseInfo>> getCourseInfo(int userId) async {
    coursation.getCourseInfo(userId)
      .then((value) => logInfo("Courses fetched: ${value.length}"))
      .catchError((error) => logError("Error fetching courses: $error"));
    return await coursation.getCourseInfo(userId);
  }
      
  Future<List<UserCourseInfo>> getAllCourses() async {
    coursation.getAllCourses()
      .then((value) => logInfo("All courses fetched: ${value.length}"))
      .catchError((error) => logError("Error fetching all courses: $error"));
    return await coursation.getAllCourses();
    
  }

  Future<void> createCourse({required String title, required int professorID}) async {
    await coursation.createCourse(title: title, professorID: professorID);
    logInfo("Course created: $title");
    await getAllCourses();
  }

  Future<bool> joinCourse({required String courseCode, required int userId}) async {
    final result = await coursation.joinCourse(courseCode: courseCode, userId: userId);
    logInfo("Joined course with code: $courseCode");
    await getAllCourses();
    return result;
  }

}
