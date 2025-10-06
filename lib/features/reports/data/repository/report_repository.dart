import 'package:flourse/features/reports/data/datasources/i_report_source.dart';
import 'package:flourse/features/reports/domain/models/reports.dart';
import 'package:flourse/features/reports/domain/repositories/i_report_repository.dart';

class ReportRepository implements IReportRepository {
  late IReportsSource reportSource;

  ReportRepository({required this.reportSource});

  @override
  Future<List<Report>> getAllReports({required String courseId}) {
    return reportSource.getAllReports(courseId: courseId);
  }

  @override
  Future<void> deleteReport(String id) {
    return reportSource.deleteReport(id);
  }

  @override
  Future<List<Report>> getReportsByUserId(String userId) {
    return reportSource.getReportsByUserId(userId);
  }

  @override
  Future<List<Report>> getReportsByGroupId(String groupId) {
    return reportSource.getReportsByGroupId(groupId);
  }

  @override
  Future<List<Report>> getReportsByEvaluationId(String evaluationId) {
    return reportSource.getReportsByEvaluationId(evaluationId);
  }

  @override
  Future<List<Report>> getReportsByCategoryId(String categoryId) {
    return reportSource.getReportsByCategoryId(categoryId);
  }
}
