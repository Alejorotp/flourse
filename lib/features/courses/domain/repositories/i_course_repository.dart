//import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';

abstract class ICourseRepository {

  Future<String> getUserNameById(String userId, String accessToken);

  Future<List<UserCourseInfo>> getCourseInfo(String userId, String accessToken);

  Future<List<UserCourseInfo>> getAllCourses(String accessToken);
  
  Future<void> createCourse({required String title, required String professorID, required String accessToken});

  Future<bool> joinCourse({required String courseCode, required String userId, required String accessToken});
}
