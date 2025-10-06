import 'package:flourse/features/reports/data/datasources/i_report_source.dart';

class ReportSourceService implements IReportsSource {
  final http.Client httpClient = Get.find<http.Client>(tag: 'apiClient');
  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  
}