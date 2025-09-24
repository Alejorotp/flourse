import 'dart:math';

import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/data/datasources/i_evaluation_source.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'dart:convert';

class EvaluationSourceService implements IEvaluationSource {
  final http.Client httpClient;

  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  final AuthenticationController authController = Get.find();

  String get _authToken => authController.accessToken.value;

  EvaluationSourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<List<Evaluation>> getByCategoryID(String categoryId) async {
    logInfo("Fetching evaluations for category ID: $categoryId");
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Evaluations&categoryID=$categoryId"),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    logInfo("Evaluations fetch response status: ${response.statusCode}");
    logInfo("Evaluations fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Evaluation(
        evaluationID: data['_id'].toString(),
        name: data['name'],
        categoryID: data['categoryID'],
        visibility: data['visibility'],
        creationDate: data['creationDate'],
      )).toList();
    } else {
      logError("Failed to fetch evaluations. Status code: ${response.statusCode}");
      return [];
    }
  }

  @override
  Future<List<Evaluation>> getAllEval() async {
    logInfo("Fetching all evaluations");
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Evaluations"),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    logInfo("All evaluations fetch response status: ${response.statusCode}");
    logInfo("All evaluations fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Evaluation(
        evaluationID: data['evaluationID'].toString(),
        name: data['name'],
        categoryID: data['categoryID'].toString(),
        visibility: data['visibility'],
        creationDate: data['creationDate'],
      )).toList();
    } else {
      logError("Failed to fetch all evaluations. Status code: ${response.statusCode}");
      return [];
    }
  }

  @override
  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate}) async {
    logInfo("Creating evaluation with name: $name, categoryId: $categoryId, visibility: $visibility, creationDate: $creationDate");

    Future<String> generateUniqueCode() async {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234S6789';
      final rand = Random();
      String Code;
      bool isUnique = false;

      while (!isUnique) {
        Code = List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
        logInfo("Generated course code: $Code");

        final response = await httpClient.get(
          Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Evaluation&evaluationID='$Code'"),
          headers: {'Authorization': 'Bearer $_authToken'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isEmpty) {
            isUnique = true;
            logInfo("Course code is unique.");
            return Code;
          } else {
            logWarning("Course code already exists. Regenerating...");
          }
        } else {
          logError("Error checking for course code uniqueness: ${response.statusCode}");
          // Stop if there's a server error to avoid an infinite loop
          throw Exception('Failed to verify course code uniqueness');
        }
      }
      // This part should not be reachable due to the return inside the loop
      throw Exception('Failed to generate a unique course code');
    }

    final code = await generateUniqueCode();
    final response = await httpClient.post(
      Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json', 
      },
      body: json.encode({
        'tableName': 'Evaluations',
        'records': {
          'name': name,
          'categoryID': categoryId,
          'visibility': visibility,
          'creationDate': creationDate,
          'evaluationID': code,
        },
      }),
    );
    logInfo("Create evaluation response status: ${response.statusCode}");
    logInfo("Create evaluation response body: ${response.body}");
    if (response.statusCode != 200) {
      logError("Failed to create evaluation. Status code: ${response.statusCode}");
      throw Exception('Failed to create evaluation');
    }

    logInfo("Evaluation created successfully with code: $code");
  }
  
}
