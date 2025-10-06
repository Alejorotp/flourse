import '../models/reports.dart';

abstract class IReportRepository {
  Future<List<Report>> getAllReports({required String courseId});
  
  Future<void> deleteReport(String id);

  Future<List<Report>> getReportsByUserId(String userId);

  Future<List<Report>> getReportsByGroupId(String groupId);

  Future<List<Report>> getReportsByEvaluationId(String evaluationId);
}