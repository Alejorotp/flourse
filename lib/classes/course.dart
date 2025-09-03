class Course {
  final String title;
  final String role;
  final int members; // Número total de miembros
  final List<String> memberIds; // Array con los IDs de los miembros
  final List<String> categories;

  Course({
    required this.title,
    required this.role,
    required this.members,
    required this.memberIds,
    required this.categories
  });
}