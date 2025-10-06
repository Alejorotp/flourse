class Report {
  final String id;
  final String userId;
  final String evaluationId;
  final String groupId;
  final String categoryId;
  final double punctuality;
  final double contributions;
  final double commitment;
  final double attitude;

  Report({
    required this.id,
    required this.userId,
    required this.evaluationId,
    required this.groupId,
    required this.categoryId,
    required this.punctuality,
    required this.contributions,
    required this.commitment,
    required this.attitude,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      userId: json['userID'],
      evaluationId: json['evaluationID'],
      groupId: json['groupID'],
      categoryId: json['categoryID'],
      punctuality: json['punctuality'],
      contributions: json['contributions'],
      commitment: json['commitment'],
      attitude: json['attitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userID': userId,
      'evaluationID': evaluationId,
      'groupID': groupId,
      'categoryID': categoryId,
      'punctuality': punctuality,
      'contributions': contributions,
      'commitment': commitment,
      'attitude': attitude,
    };
  }
}