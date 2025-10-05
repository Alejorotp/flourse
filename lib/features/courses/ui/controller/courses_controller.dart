import 'package:get/get.dart';
import '../../domain/models/course.dart';
import '../../domain/models/course_info.dart';
import '../../../auth/ui/controller/auth_controller.dart';

import 'package:loggy/loggy.dart';

import '../../domain/use_case/course_usecase.dart';

class CoursesController extends GetxController {
  final CourseUseCase coursation;
  final AuthenticationController authController = Get.find();
  CoursesController(this.coursation);

  var courses = <Course>[].obs;
  var userCourses = <UserCourseInfo>[].obs;
  String? _currentUserId;

  // Call this when user logs in or id changes
  Future<void> loadUserCourses(String userId) async {
    
    _currentUserId = userId;
    try {
      final result = await coursation.getCourseInfo(userId, authController.accessToken.value);
      userCourses.assignAll(result);
      logInfo("User courses loaded: \\${result.length}");
    } catch (e) {
      logError("Error loading user courses: $e");
    }
  }

  Future<List<UserCourseInfo>> getAllCourses() async {
    coursation.getAllCourses(authController.accessToken.value)
      .then((value) => logInfo("All courses fetched: \\${value.length}"))
      .catchError((error) => logError("Error fetching all courses: $error"));
    return await coursation.getAllCourses(authController.accessToken.value);
  }

  Future<bool> createCourse({required String title, required String professorID}) async {
    // Contar cursos donde el usuario es profesor
    final profCourses = userCourses.where((c) => c.userRole == 'Profesor').toList();
    if (profCourses.length >= 3) {
      logInfo("User already professor of 3 or more courses");
      return false;
    }
    await coursation.createCourse(title: title, professorID: professorID, accessToken: authController.accessToken.value);
    logInfo("Course created: $title");
    if (_currentUserId != null) {
      await loadUserCourses(_currentUserId!);
    }
    await getAllCourses();
    return true;
  }

  Future<bool> joinCourse({required String courseCode, required String userId}) async {
    final result = await coursation.joinCourse(courseCode: courseCode, userId: userId, accessToken: authController.accessToken.value);
    logInfo("Joined course with code: $courseCode");
    if (_currentUserId != null) {
      await loadUserCourses(_currentUserId!);
    }
    await getAllCourses();
    return result;
  }

  Future<String> getUserNameById(String userId) {
    Future<String> userName = coursation.getUserNameById(userId, authController.accessToken.value);
    logInfo("Fetched user name for ID $userId");
    return userName;
  }
}