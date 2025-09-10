import '../repositories/i_course_repository.dart';
import '../models/course.dart';
import '../models/course_info.dart';

class CourseUseCase {
  final ICourseRepository _repository;

  CourseUseCase(this._repository);

  Future<UserCourseInfo> getCourseInfo(String courseCode, String userId) async =>
      await _repository.getCourseInfo(courseCode, userId);
  
  Future<List<Course>> getAllCourses() async => await _repository.getAllCourses();

  Future<void> createCourse({required String title, required int professorID}) async =>
      await _repository.createCourse(title: title, professorID: professorID);
      
}
