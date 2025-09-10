import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';

abstract class ICourseRepository {

  Future<String> getUserNameById(int userId);

  Future<List<UserCourseInfo>> getCourseInfo(int userId);

  Future<List<UserCourseInfo>> getAllCourses();
  
  Future<void> createCourse({required String title, required int professorID});

  Future<bool> joinCourse({required String courseCode, required int userId});
}
