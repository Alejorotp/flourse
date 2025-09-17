
import '../../domain/repositories/i_course_repository.dart';
import '../datasources/i_course_source.dart';
//import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';



class CourseRepository implements ICourseRepository {
  late ICourseSource courseSource;

  CourseRepository(this.courseSource);

  @override
  Future<String> getUserNameById(String userId) {
    return courseSource.getUserNameById(userId);
  }

  @override
  Future<List<UserCourseInfo>> getCourseInfo(String userId) {
    return courseSource.getCourseInfo(userId);
  }

  @override
  Future<List<UserCourseInfo>> getAllCourses() {
    return courseSource.getAllCourses();
  }

  @override
  Future<void> createCourse({required String title, required String professorID}) {
    return courseSource.createCourse(title: title, professorID: professorID);
  }
 
  @override
  Future<bool> joinCourse({required String courseCode, required String userId}) {
    return courseSource.joinCourse(courseCode: courseCode, userId: userId);
  }
}
