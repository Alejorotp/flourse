class Category {
  final int id;
  final String name;
  final String groupingMethod; // "Random" or "Self-assigned"
  final int maxMembers;

  Category({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.maxMembers,
  });
}
