class Report {
  final String id;
  final String userId;
  final String evaluatorId;
  final String courseId;
  final String evaluationId;
  final String groupId;
  final String categoryId;
  final String punctuality;
  final String contributions;
  final String commitment;
  final String attitude;

  Report({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.evaluatorId,
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
      courseId: json['courseID'],
      evaluationId: json['evaluationID'],
      evaluatorId: json['evaluatorID'],
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
      'courseID': courseId,
      'evaluationID': evaluationId,
      'evaluatorID': evaluatorId,
      'groupID': groupId,
      'categoryID': categoryId,
      'punctuality': punctuality,
      'contributions': contributions,
      'commitment': commitment,
      'attitude': attitude,
    };
  }
}