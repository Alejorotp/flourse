class Category {
  final String id;
  final String name;
  final String groupingMethod; // "Random" or "Self-assigned"
  final int maxMembers;
  List<String> groupIDs = [];

  Category({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.maxMembers,
    this.groupIDs = const [],
  });
}
