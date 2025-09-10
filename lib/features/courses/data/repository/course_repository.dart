
import '../../domain/repositories/i_course_repository.dart';
import '../datasources/local/i_course_source.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';



class CourseRepository implements ICourseRepository {
  late ICourseSource courseSource;

  CourseRepository(this.courseSource);

  @override
  Future<String> getUserNameById(int userId) {
    return courseSource.getUserNameById(userId);
  }

  @override
  Future<List<UserCourseInfo>> getCourseInfo(int userId) {
    return courseSource.getCourseInfo(userId);
  }

  @override
  Future<List<Course>> getAllCourses() {
    return courseSource.getAllCourses();
  }

  @override
  Future<void> createCourse({required String title, required int professorID}) {
    return courseSource.createCourse(title: title, professorID: professorID);
  }
 
  @override
  Future<bool> joinCourse({required String courseCode, required int userId}) {
    return courseSource.joinCourse(courseCode: courseCode, userId: userId);
  }
}
