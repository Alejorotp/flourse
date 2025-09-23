class Course {
  final String title;
  final String professorID;
  final String courseCode;
  final List<String>? memberIDs; // Array con los IDs de los miembros
  final List<String>? categoryIDs; // Array con las categorías del curso
  final String? registerCode; // Código de registro opcional

  Course({
    required this.title,
    required this.professorID,
    required this.courseCode,
    required this.memberIDs,
    required this.categoryIDs,
    this.registerCode,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title'],
      professorID: json['professorID'],
      courseCode: json['courseCode'],
      memberIDs: List<String>.from(json['memberIDs'] ?? []),
      categoryIDs: List<String>.from(json['categoryIDs'] ?? []),
      registerCode: json['registerCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'professorID': professorID,
      'courseCode': courseCode,
      'memberIDs': memberIDs,
      'categoryIDs': categoryIDs,
      'registerCode': registerCode,
    };
  }
}
