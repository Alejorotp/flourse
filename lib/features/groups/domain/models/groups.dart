class Group {
  final String id;
  final int maxMembers;
  List<String> memberIDs = [];

  Group({
    required this.id,
    required this.maxMembers,
    this.memberIDs = const [],
  });
}
