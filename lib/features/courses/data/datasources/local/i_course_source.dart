import '../../../domain/models/course.dart';
import '../../../domain/models/course_info.dart';

abstract class ICourseSource {
  Future<UserCourseInfo> getCourseInfo(String courseCode, String userId);

  Future<List<Course>> getAllCourses();
  
  Future<void> createCourse({required String title, required int professorID});

}
