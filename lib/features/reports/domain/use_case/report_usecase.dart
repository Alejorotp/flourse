import 'package:flourse/features/reports/domain/models/reports.dart';
import '../repositories/i_report_repository.dart';

class ReportUseCase {
  final IReportRepository _repository;

  ReportUseCase(this._repository);

  Future<List<Report>> getAllReports({required String courseId}) {
    return _repository.getAllReports(courseId: courseId);
  }

  Future<void> deleteReport(String id) {
    return _repository.deleteReport(id);
  }

  Future<List<Report>> getReportsByUserId(String userId) {
    return _repository.getReportsByUserId(userId);
  }

  Future<List<Report>> getReportsByGroupId(String groupId) {
    return _repository.getReportsByGroupId(groupId);
  }

  Future<List<Report>> getReportsByEvaluationId(String evaluationId) {
    return _repository.getReportsByEvaluationId(evaluationId);
  }
}