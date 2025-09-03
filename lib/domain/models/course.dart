class Course {
  final String title;
  final String professorID;
  final List<String> memberIds; // Array con los IDs de los miembros
  final List<String> categories;

  Course({
    required this.title,
    required this.professorID,
    required this.memberIds,
    required this.categories
  });
}