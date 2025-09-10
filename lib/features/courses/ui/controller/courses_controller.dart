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
      
  Future<List<Course>> getAllCourses() async {
    courses.value = await coursation.getAllCourses();
    logInfo("Courses fetched: ${courses.length}");
    return courses;
  }

  Future<void> createCourse({required String title, required int professorID}) async {
    await coursation.createCourse(title: title, professorID: professorID);
    logInfo("Course created: $title");
    await getAllCourses();
  }

  

}
