import '../repositories/i_course_repository.dart';
//import '../models/course.dart';
import '../models/course_info.dart';

class CourseUseCase {
  final ICourseRepository _repository;

  CourseUseCase(this._repository);

  Future<String> getUserNameById(String userId) async =>
    await _repository.getUserNameById(userId);
  

  Future<List<UserCourseInfo>> getCourseInfo(String userId) async =>
      await _repository.getCourseInfo(userId);
  
  Future<List<UserCourseInfo>> getAllCourses() async => await _repository.getAllCourses();

  Future<void> createCourse({required String title, required String professorID}) async =>
      await _repository.createCourse(title: title, professorID: professorID);

  Future<bool> joinCourse({required String courseCode, required String userId}) async =>
      await _repository.joinCourse(courseCode: courseCode, userId: userId);

}
