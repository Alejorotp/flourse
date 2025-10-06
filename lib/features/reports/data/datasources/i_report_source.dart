import 'package:flourse/features/reports/domain/models/reports.dart';

abstract class IReportsSource {
  Future<List<Report>> getAllReports({required String courseId});

  Future<Report> createReport({
    required String courseId,
    required String title,
    required String description,
    required String categoryId,
    required String visibility,
  });

  Future<void> deleteReport(String id);

  Future<List<Report>> getReportsByUserId(String userId);

  Future<List<Report>> getReportsByGroupId(String groupId);

  Future<List<Report>> getReportsByEvaluationId(String evaluationId);
}