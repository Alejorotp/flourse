import 'dart:convert';
import 'package:flourse/features/groups/data/datasources/i_group_source.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart'; 

class GroupSourceService implements IGroupSource {
  final http.Client httpClient;
  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";
  
  // Instancia del AuthenticationController, como un singleton, gracias a GetX
  final AuthenticationController authController = Get.find();

  GroupSourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  // Getter para obtener el token de manera reactiva
  String get _authToken => authController.accessToken.value;

  @override
  Future<List<Group>> getAllGroups() async {
    logInfo("Fetching all groups from API");
    try {
      final response = await httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Group"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Group> fetchedGroups = jsonList.map((json) => Group.fromJson(json)).toList();
        return fetchedGroups;
      } else {
        logError("Failed to fetch groups: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logError("Error fetching groups: $e");
      return [];
    }
  }

  @override
  Future<Group?> getGroupById(String id) async {
    logInfo("Fetching group by ID from API: $id");
    try {
      final response = await httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Group&_id=$id"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isNotEmpty) {
          return Group.fromJson(jsonList.first);
        }
      }
    } catch (e) {
      logError("Error fetching group by ID: $e");
    }
    return null;
  }

  @override
  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber
  }) async {
    logInfo("Creating group on API with maxMembers: $maxMembers for category: $categoryId");
    try {
      final response = await httpClient.post(
        Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'groups',
          'records': [
            {
              'groupNumber': groupNumber,
              'maxMembers': maxMembers,
              'memberIDs': [], // No existe así que toca 
              'categoryId': categoryId,
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['inserted'].isNotEmpty) {
          return Group.fromJson(responseData['inserted'][0]);
        }
      }
      logError("Failed to create group: ${response.statusCode}");
      throw Exception('Failed to create group');
    } catch (e) {
      logError("Error creating group: $e");
      rethrow;
    }
  }

  @override
  Future<bool> joinGroup(String groupId, String userId) async {
    logInfo("User with ID: $userId joining group with ID: $groupId on API");
    try {
      final response = await httpClient.put(
        Uri.parse("$_apiBaseUrl/$_databaseName/update"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'groups',
          'idColumn': '_id',
          'idValue': groupId,
          'updates': {
            'memberIDs': [...(await getGroupById(groupId))!.memberIDs, userId]
          },
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      logError("Error joining group: $e");
    }
    return false;
  }

  @override
  Future<bool> removeMemberFromGroup(String groupId, String userId) async {
    logInfo("User with ID: $userId being removed from group with ID: $groupId on API");
    try {
      final group = await getGroupById(groupId);
      if (group == null || !group.memberIDs.contains(userId)) {
        return false;
      }
      final updatedMembers = group.memberIDs..remove(userId);
      final response = await httpClient.put(
        Uri.parse("$_apiBaseUrl/$_databaseName/update"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'groups',
          'idColumn': '_id',
          'idValue': groupId,
          'updates': {'memberIDs': updatedMembers},
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      logError("Error removing member from group: $e");
    }
    return false;
  }

  @override
  Future<void> deleteGroup(String id) async {
    logInfo("Deleting group with id: $id from API");
    try {
      final response = await httpClient.delete(
        Uri.parse("$_apiBaseUrl/$_databaseName/delete"),
        headers: {
          'Authorization': 'Bearer $_authToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'groups',
          'idColumn': '_id',
          'idValue': id,
        }),
      );
      if (response.statusCode == 200) {
        logInfo("Group $id deleted successfully from API");
      } else {
        logWarning("Failed to delete group $id: ${response.statusCode}");
      }
    } catch (e) {
      logError("Error deleting group: $e");
    }
  }
}