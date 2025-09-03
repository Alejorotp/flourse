import 'package:get/get.dart';
import 'package:flourse/domain/models/course.dart';
import 'package:flourse/data/data.dart';

class CoursesController extends GetxController {
  RxList<Course> courses = RxList<Course>(myCourses);

  void addCourse(Course course) {
    courses.add(course);
    myCourses.add(course); // Para mantener la compatibilidad
    update();
  }
}