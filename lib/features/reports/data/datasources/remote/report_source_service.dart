import 'package:flourse/features/reports/data/datasources/i_report_source.dart';
import 'package:flourse/features/reports/domain/models/reports.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'dart:convert';

import 'package:loggy/loggy.dart';

class ReportSourceService implements IReportsSource {
  final http.Client httpClient = Get.find<http.Client>(tag: 'apiClient');
  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  final AuthenticationController authController = Get.find();

  String get _authToken => authController.accessToken.value;

  @override
  Future<List<Report>> getAllReports({required String courseId}) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_apiBaseUrl/$_databaseName/reports?courseId=$courseId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$_apiBaseUrl/$_databaseName/reports/$id'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete report');
      }
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  @override
  Future<List<Report>> getReportsByUserId(String userId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_apiBaseUrl/$_databaseName/reports?userId=$userId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  @override
  Future<List<Report>> getReportsByGroupId(String groupId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_apiBaseUrl/$_databaseName/reports?groupId=$groupId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  @override
  Future<List<Report>> getReportsByEvaluationId(String evaluationId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&evaluationID=$evaluationId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );
      logInfo(response.body);
      logInfo(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  @override
  Future<List<Report>> getReportsByCategoryId(String categoryId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$_apiBaseUrl/$_databaseName/reports?categoryId=$categoryId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );
      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }
}