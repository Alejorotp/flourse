class Group {
  final int id;
  final int maxMembers;
  List<int> memberIDs = [];

  Group({
    required this.id,
    required this.maxMembers,
    this.memberIDs = const [],
  });
}
