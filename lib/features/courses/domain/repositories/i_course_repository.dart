//import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';

abstract class ICourseRepository {

  Future<String> getUserNameById(String userId);

  Future<List<UserCourseInfo>> getCourseInfo(String userId);

  Future<List<UserCourseInfo>> getAllCourses();
  
  Future<void> createCourse({required String title, required String professorID});

  Future<bool> joinCourse({required String courseCode, required String userId});
}
