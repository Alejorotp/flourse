class Category {
  String? id;
  final String name;
  final String groupingMethod; // "Random" or "Self-assigned"
  final int maxMembers;
  final String? courseId;
  List<String> groupIDs = [];

  Category({
    this.id,
    required this.name,
    required this.groupingMethod,
    required this.maxMembers,
    required this.courseId,
    this.groupIDs = const [],
  });
}
