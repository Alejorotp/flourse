
import '../../domain/repositories/i_course_repository.dart';
import '../datasources/i_course_source.dart';
//import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';



class CourseRepository implements ICourseRepository {
  late ICourseSource courseSource;

  CourseRepository(this.courseSource);

  @override
  Future<String> getUserNameById(String userId, String accessToken) {
    return courseSource.getUserNameById(userId, accessToken);
  }

  @override
  Future<List<UserCourseInfo>> getCourseInfo(String userId, String accessToken) {
    return courseSource.getCourseInfo(userId, accessToken);
  }

  @override
  Future<List<UserCourseInfo>> getAllCourses(String accessToken) {
    return courseSource.getAllCourses(accessToken);
  }

  @override
  Future<void> createCourse({required String title, required String professorID, required String accessToken}) {
    return courseSource.createCourse(title: title, professorID: professorID, accessToken: accessToken);
  }
 
  @override
  Future<bool> joinCourse({required String courseCode, required String userId, required String accessToken}) {
    return courseSource.joinCourse(courseCode: courseCode, userId: userId, accessToken: accessToken);
  }
}
