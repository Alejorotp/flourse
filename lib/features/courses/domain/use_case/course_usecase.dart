import '../repositories/i_course_repository.dart';
import '../models/course.dart';
import '../models/course_info.dart';

class CourseUseCase {
  final ICourseRepository _repository;

  CourseUseCase(this._repository);

  Future<String> getUserNameById(int userId) async {
    // Simula una llamada a una fuente de datos para obtener el nombre del usuario
    await Future.delayed(Duration(milliseconds: 100)); // Simula un retardo
    // Aquí deberías implementar la lógica real para obtener el nombre del usuario
    return "Usuario $userId"; // Retorna un nombre simulado
  }

  Future<List<UserCourseInfo>> getCourseInfo(int userId) async =>
      await _repository.getCourseInfo(userId);
  
  Future<List<Course>> getAllCourses() async => await _repository.getAllCourses();

  Future<void> createCourse({required String title, required int professorID}) async =>
      await _repository.createCourse(title: title, professorID: professorID);

  

}
