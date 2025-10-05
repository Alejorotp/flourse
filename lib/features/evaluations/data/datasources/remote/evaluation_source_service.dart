import 'dart:math';
import 'package:flourse/features/evaluations/domain/models/score.dart';  
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/data/datasources/i_evaluation_source.dart';
import 'package:get/get.dart';
import 'dart:convert';

class EvaluationSourceService implements IEvaluationSource {
  final http.Client httpClient = Get.find<http.Client>(tag: 'apiClient');

  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  //EvaluationSourceService({http.Client? client})
  //  : httpClient = client ?? http.Client();

  @override
  Future<List<Evaluation>> getByCategoryID(String categoryId, String accessToken) async {
    logInfo("Fetching evaluations for category ID: $categoryId");
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Evaluations&categoryID=$categoryId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
  Future<List<Evaluation>> getAllEval(String accessToken) async {
    logInfo("Fetching all evaluations");
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Evaluations"),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate, required String accessToken}) async {
    logInfo("Creating evaluation with name: $name, categoryId: $categoryId, visibility: $visibility, creationDate: $creationDate");

    String generateUniqueCode() {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234S6789';
      final rand = Random();
      String code = List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
      return code;
    }

    final code = generateUniqueCode();
    final response = await httpClient.post(
      Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json', 
      },
      body: json.encode({
        'tableName': 'Evaluations',
        'records': [{
          'name': name,
          'categoryID': categoryId,
          'visibility': visibility,
          'creationDate': creationDate,
          'evaluationID': code,
        }],
      }),
    );
    logInfo("Create evaluation response status: ${response.statusCode}");
    logInfo("Create evaluation response body: ${response.body}");
    if (response.statusCode != 201) {
      logError("Failed to create evaluation. Status code: ${response.statusCode}");
      throw Exception('Failed to create evaluation');
    }

    logInfo("Evaluation created successfully with code: $code");
  }


  @override
  Future<List<String>> getScoresByCategoryID(String categoryId, String evaluationId, String accessToken) async {
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&categoryID=$categoryId&evaluationID=$evaluationId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    logInfo("Scores by category fetch response status: ${response.statusCode}");
    logInfo("Scores by category fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Score(
        punctuality: data['punctuality'],
        contributions: data['contributions'],
        commitment: data['commitment'],
        attitude: data['attitude'],
      ).toString()).toList();
    } else {
      logError("Failed to fetch scores by category. Status code: ${response.statusCode}");
      return [];
    }

  }

  @override
  Future<List<String>> getScoresByEvaluationID(String evaluationId, String accessToken) async {
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&evaluationID=$evaluationId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    logInfo("Scores by evaluation fetch response status: ${response.statusCode}");
    logInfo("Scores by evaluation fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Score(
        punctuality: data['punctuality'],
        contributions: data['contributions'],
        commitment: data['commitment'],
        attitude: data['attitude'],
      ).toString()).toList();
    } else {
      logError("Failed to fetch scores by evaluation. Status code: ${response.statusCode}");
      return [];
    }
  }

  @override
  Future<List<String>> getScoresByGroupID(String groupId, String evaluationId, String accessToken) async {
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&groupID=$groupId&evaluationID=$evaluationId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    logInfo("Scores by group fetch response status: ${response.statusCode}");
    logInfo("Scores by group fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Score(
        punctuality: data['punctuality'],
        contributions: data['contributions'],
        commitment: data['commitment'],
        attitude: data['attitude'],
      ).toString()).toList();
    } else {
      logError("Failed to fetch scores by group. Status code: ${response.statusCode}");
      return [];
    }
  }


  @override
  Future<List<String>> getUserScores(String userId, String evaluationId, String accessToken) async {
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&userID=$userId&evaluationID=$evaluationId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    logInfo("User scores fetch response status: ${response.statusCode}");
    logInfo("User scores fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Score(
        punctuality: data['punctuality'],
        contributions: data['contributions'],
        commitment: data['commitment'],
        attitude: data['attitude'],
      ).toString()).toList();
    } else {
      logError("Failed to fetch user scores. Status code: ${response.statusCode}");
      return [];
    }
  }

  @override
  Future<List<String>> getAllUserScores(String userId, String accessToken) async {
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=EvaluationScore&userID=$userId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    logInfo("All user scores fetch response status: ${response.statusCode}");
    logInfo("All user scores fetch response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      return responseData.map((data) => Score(
        punctuality: data['punctuality'],
        contributions: data['contributions'],
        commitment: data['commitment'],
        attitude: data['attitude'],
      ).toString()).toList();
    } else {
      logError("Failed to fetch all user scores. Status code: ${response.statusCode}");
      return [];
    }
  }


  @override
  Future<void> submitScore({required String userId, required String evaluationId, required String groupID, required String categoryID, required Score scores, required String accessToken}) async {
    logInfo("Submitting score for userId: $userId, evaluationId: $evaluationId, groupID: $groupID, categoryID: $categoryID");

    final response = await httpClient.post(
      Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'tableName': 'EvaluationScore',
        'records': [{
          'userID': userId,
          'evaluationID': evaluationId,
          'groupID': groupID,
          'categoryID': categoryID,
          'punctuality': scores.punctuality,
          'contributions': scores.contributions,
          'commitment': scores.commitment,
          'attitude': scores.attitude,
        }],
      }),
    );

    logInfo("Submit score response status: ${response.statusCode}");
    logInfo("Submit score response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : [];
      logInfo("Score submitted successfully: $responseData");
    } else {
      logError("Failed to submit score. Status code: ${response.statusCode}");
      throw Exception('Failed to submit score');
    }
  }

  @override
  Future<List<Evaluation>> getUserEvaluations(String userId, String accessToken) async {
    logInfo("Fetching user evaluations for user: $userId");
    // This method should be implemented to get evaluations for a specific user
    // For now, return an empty list as this requires proper implementation
    // through the use case layer that can coordinate with groups
    return [];
  }


  




}
