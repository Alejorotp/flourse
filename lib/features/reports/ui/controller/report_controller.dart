import 'package:get/get.dart';
import 'package:flourse/features/reports/domain/models/reports.dart';
import 'package:flourse/features/reports/domain/use_case/report_usecase.dart';
import 'package:loggy/loggy.dart';

class ReportController extends GetxController {
  final ReportUseCase reportUseCase;

  ReportController(this.reportUseCase);

  var reports = <Report>[].obs;

  Future<void> fetchAllReports({required String courseId}) async {
    try {
      final fetchedReports = await reportUseCase.getAllReports(courseId: courseId);
      reports.assignAll(fetchedReports);
      logInfo("Fetched ${fetchedReports.length} reports for course $courseId");
    } catch (e) {
      logError("Error fetching reports: $e");
    }
  }

  Future<void> fetchReportsByUserId(String userId) async {
    try {
      final fetchedReports = await reportUseCase.getReportsByUserId(userId);
      reports.assignAll(fetchedReports);
      logInfo("Fetched ${fetchedReports.length} reports for user $userId");
    } catch (e) {
      logError("Error fetching reports by user: $e");
    }
  }

  Future<void> fetchReportsByGroupId(String groupId) async {
    try {
      final fetchedReports = await reportUseCase.getReportsByGroupId(groupId);
      reports.assignAll(fetchedReports);
      logInfo("Fetched ${fetchedReports.length} reports for group $groupId");
    } catch (e) {
      logError("Error fetching reports by group: $e");
    }
  }

  Future<void> fetchReportsByEvaluationId(String evaluationId) async {
    try {
      final fetchedReports = await reportUseCase.getReportsByEvaluationId(evaluationId);
      reports.assignAll(fetchedReports);
      logInfo("Fetched ${fetchedReports.length} reports for evaluation $evaluationId");
    } catch (e) {
      logError("Error fetching reports by evaluation: $e");
    }
  }

  Future<void> fetchReportsByCategoryId(String categoryId) async {
    try {
      final fetchedReports = await reportUseCase.getReportsByCategoryId(categoryId);
      reports.assignAll(fetchedReports);
      logInfo("Fetched ${fetchedReports.length} reports for category $categoryId");
    } catch (e) {
      logError("Error fetching reports by category: $e");
    }
  }

  Future<void> deleteReport(String id, {String? courseId}) async {
    try {
      await reportUseCase.deleteReport(id);
      logInfo("Deleted report $id");
      // Optionally refresh the list after deletion
      if (courseId != null) {
        await fetchAllReports(courseId: courseId);
      }
    } catch (e) {
      logError("Error deleting report: $e");
    }
  }
}