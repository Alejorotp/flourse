class Course {
  final String title;
  final int professorID;
  final String courseCode;
  final List<int> memberIDs; // Array con los IDs de los miembros
  final List<int> categoryIDs; // Array con las categorías del curso
  final String? registerCode; // Código de registro opcional

  Course({
    required this.title,
    required this.professorID,
    required this.courseCode,
    required this.memberIDs,
    required this.categoryIDs,
    this.registerCode,
  });
}
