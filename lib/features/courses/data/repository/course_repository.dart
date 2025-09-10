
import '../../domain/repositories/i_course_repository.dart';
import '../datasources/local/i_course_source.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';



class CourseRepository implements ICourseRepository {
  late ICourseSource courseSource;

  CourseRepository(this.courseSource);

  @override
  Future<UserCourseInfo> getCourseInfo(String courseCode, String userId) {
    return courseSource.getCourseInfo(courseCode, userId);
  }

  @override
  Future<List<Course>> getAllCourses() {
    return courseSource.getAllCourses();
  }

  @override
  Future<void> createCourse({required String title, required int professorID}) {
    return courseSource.createCourse(title: title, professorID: professorID);
  }
 
}
