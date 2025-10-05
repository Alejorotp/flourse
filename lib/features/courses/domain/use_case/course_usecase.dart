import '../repositories/i_course_repository.dart';
//import '../models/course.dart';
import '../models/course_info.dart';

class CourseUseCase {
  final ICourseRepository _repository;

  CourseUseCase(this._repository);

  Future<String> getUserNameById(String userId, String accessToken) async =>
    await _repository.getUserNameById(userId, accessToken);
  

  Future<List<UserCourseInfo>> getCourseInfo(String userId, String accessToken) async =>
      await _repository.getCourseInfo(userId, accessToken);
  
  Future<List<UserCourseInfo>> getAllCourses(String accessToken) async => await _repository.getAllCourses(accessToken);

  Future<void> createCourse({required String title, required String professorID, required String accessToken}) async =>
      await _repository.createCourse(title: title, professorID: professorID, accessToken: accessToken);

  Future<bool> joinCourse({required String courseCode, required String userId, required String accessToken}) async =>
      await _repository.joinCourse(courseCode: courseCode, userId: userId, accessToken: accessToken);

}
