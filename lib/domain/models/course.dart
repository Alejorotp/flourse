class Course {
  final String title;
  final String professorID;
  final int members; // Número total de miembros
  final List<String> memberIds; // Array con los IDs de los miembros
  final List<String> categories;

  Course({
    required this.title,
    required this.professorID,
    required this.members,
    required this.memberIds,
    required this.categories
  });
}