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

  List<double> userAverageScore(String id, {String? courseId, String? categoryId, String? evaluationId, String? groupId }) {
    List<Report> userReports = reports.where((report) => report.userId == id).toList();
    logInfo("Calculating average for user $id with ${userReports.length} reports before filtering");
    if (courseId != null) {
      logError("courseId: $courseId");
      userReports = userReports.where((report) => report.courseId == courseId).toList();
    } else if (categoryId != null) {
      logError("categoryId: $categoryId");
      userReports = userReports.where((report) => report.categoryId == categoryId).toList();
    } else if (evaluationId != null) {
      logError("evaluationId: $evaluationId"); 
      userReports = userReports.where((report) => report.evaluationId == evaluationId).toList();
    } else if (groupId != null) {
      logError("groupId: $groupId");
      userReports = userReports.where((report) => report.groupId == groupId).toList();
    }
    logError("Calculating average for user $id with ${userReports.length} reports after filtering");

    if (userReports.isEmpty) {
      logInfo("No reports found for user $id with the given filters");
      return [0.0, 0.0, 0.0, 0.0];
    }

    double totalPunctuality = 0;
    double totalContributions = 0;
    double totalCommitment = 0;
    double totalAttitude = 0;
    double count = 0;
    logInfo("Calculating average for user $id with ${userReports.length} reports");

    for (var report in userReports) {
      totalPunctuality += double.tryParse(report.punctuality) ?? 0.0;
      totalContributions += double.tryParse(report.contributions) ?? 0.0;
      totalCommitment += double.tryParse(report.commitment) ?? 0.0;
      totalAttitude += double.tryParse(report.attitude) ?? 0.0;
      count++;
    }

    return [
      (totalPunctuality / count),
      (totalContributions / count),
      (totalCommitment / count),
      (totalAttitude / count),
    ];
  }

  List<double> groupAverageScore(String groupId) {
    var groupReports = reports.where((report) => report.groupId == groupId);
    if (groupReports.isEmpty) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    double totalPunctuality = 0;
    double totalContributions = 0;
    double totalCommitment = 0;
    double totalAttitude = 0;
    double count = 0;

    for (var report in groupReports) {
      totalPunctuality += double.tryParse(report.punctuality) ?? 0.0;
      totalContributions += double.tryParse(report.contributions) ?? 0.0;
      totalCommitment += double.tryParse(report.commitment) ?? 0.0;
      totalAttitude += double.tryParse(report.attitude) ?? 0.0;
      count++;
    }

    return [
      (totalPunctuality / count),
      (totalContributions / count),
      (totalCommitment / count),
      (totalAttitude / count),
    ];
  }

  List<double> activityAverageScore(String evaluationId) {
    var activityReports = reports.where((report) => report.evaluationId == evaluationId);
    if (activityReports.isEmpty) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    double totalPunctuality = 0;
    double totalContributions = 0;
    double totalCommitment = 0;
    double totalAttitude = 0;
    double count = 0;

    for (var report in activityReports) {
      totalPunctuality += double.tryParse(report.punctuality) ?? 0.0;
      totalContributions += double.tryParse(report.contributions) ?? 0.0;
      totalCommitment += double.tryParse(report.commitment) ?? 0.0;
      totalAttitude += double.tryParse(report.attitude) ?? 0.0;
      count++;
    }

    return [
      (totalPunctuality / count),
      (totalContributions / count),
      (totalCommitment / count),
      (totalAttitude / count),
    ];
  }

  List<String>? getScore(String id, String evaluatorId, String evaluationId){
    logInfo("Getting score for user $id evaluated by $evaluatorId for evaluation $evaluationId");
    var report = reports.firstWhere(
      (report) => report.userId == id && report.evaluatorId == evaluatorId && report.evaluationId == evaluationId,
      orElse: () => Report(
        id: '',
        userId: '',
        evaluatorId: '',
        evaluationId: '',
        courseId: '',
        groupId: '',
        categoryId: '',
        punctuality: '0',
        contributions: '0',
        commitment: '0',
        attitude: '0',
      ),
    );
    logInfo("Found report: ${report.toJson()}");

    if (report.id.isEmpty) {
      return null;
    } else {
      return [
        report.punctuality,
        report.contributions,
        report.commitment,
        report.attitude,
      ];
    }




  }

}