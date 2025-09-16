class Category {
  final int id;
  final String name;
  final String groupingMethod; // "Random" or "Self-assigned"
  final int maxMembers;
  List<int> groupIDs = [];

  Category({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.maxMembers,
    this.groupIDs = const [],
  });
}
