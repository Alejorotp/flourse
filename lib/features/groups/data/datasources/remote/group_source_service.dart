import 'dart:convert';
//import 'package:flourse/features/auth/ui/pages/login.dart';
import 'package:flourse/features/groups/data/datasources/i_group_source.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
class GroupSourceService implements IGroupSource {
  final http.Client httpClient = Get.find<http.Client>(tag: 'apiClient');
  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  @override
  Future<List<Group>> getAllGroups(String accessToken) async {
    logInfo("Fetching all groups from API");
    try {
      final response = await httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Group"),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {

        final List<dynamic> jsonList = json.decode(response.body);
        logError("Groups fetch response body: ${response.body}");
        

        
        final List<Group>fetchedGroups = [];
        for (var data in jsonList) {
          final maxMemberResponses = await httpClient.get(
          Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Category&_id=${data['categoryID'].toString()}"),
          headers: {
            'Authorization' : 'Bearer $_authToken',
          }
        );
          int maxMembers = 0;
          if (maxMemberResponses.statusCode == 200) {
            final List<dynamic> categoryList = json.decode(maxMemberResponses.body);
            if (categoryList.isNotEmpty) {
              maxMembers = categoryList[0]['maxMembers'] ?? 0;
            }
            logError("Fetched maxMembers: $maxMembers for categoryID ${data['categoryID']}");
          } else {
            logError("Failed to fetch maxMembers for categoryID ${data['categoryID']}: ${maxMemberResponses.statusCode}");
          }

          final memberIDsResponse = await httpClient.get(
            Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=GroupMember&groupID=${data['_id'].toString()}"),
            headers: {
              'Authorization' : 'Bearer $_authToken',
            }
          );
          List<String> memberIDs = [];
          if (memberIDsResponse.statusCode == 200) {
            final List<dynamic> memberList = json.decode(memberIDsResponse.body);
            memberIDs = memberList.map((member) => member['userID'].toString()).toList();
            logError("Fetched memberIDs: $memberIDs for groupID ${data['_id']}");
          } else {
            logError("Failed to fetch memberIDs for groupID ${data['_id']}: ${memberIDsResponse.statusCode}");
          }


          final group = Group(
            id: data['_id'].toString(),
            memberIDs: memberIDs,
            categoryID: data['categoryID'].toString(),
          );
          logInfo("Fetched group: ${group.id} with memberIDs: ${group.memberIDs} and categoryID: ${group.categoryID}");
          fetchedGroups.add(group);
        }
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
  Future<List<Group>> getGroupById(String id, String accessToken) async {
    logInfo("Fetching group by ID from API: $id");
    try {
      var groups = await getAllGroups(accessToken);
      groups = groups.where((group) => group.id == id).toList();
      return groups;
    } catch (e) {
      logError("Error fetching group by ID: $e");
    }
    return [];
  }

  @override
  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber,
    required String accessToken
  }) async {
    logInfo("Creating group on API with maxMembers: $maxMembers for category: $categoryId");
    try {
      final response = await httpClient.post(
        Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
        headers: {
          'Authorization': 'Bearer $accessToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'Group',
          'records': [
            {
              'groupNumber': groupNumber,
              'categoryID': categoryId,
            },
          ],
        }),
      );
      if (response.statusCode == 201) {
        logError("Group creation response body: ${response.body}");
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['inserted'].isNotEmpty) {
          logInfo("Group created successfully: ${responseData['inserted'][0]['_id']}");
          logError(responseData['inserted'][0]);
          return Group(
            id: responseData['inserted'][0]['_id'].toString(),
            memberIDs: [],
            categoryID: categoryId,
            groupNumber: groupNumber,
          );
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
  Future<bool> joinGroup(String groupId, String userId, String accessToken) async {
    logInfo("User with ID: $userId joining group with ID: $groupId on API");
    try {
      final response = await httpClient.post(
        Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
        headers: {
          'Authorization': 'Bearer $accessToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tableName': 'GroupMember',
          'records': [
            {
              'groupID': groupId,
              'userID': userId,
            },
          ],
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        logWarning("Failed to join group: ${response.statusCode}");
      }
    } catch (e) {
      logError("Error joining group: $e");
    }
    return false;
  }

  @override
  Future<bool> removeMemberFromGroup(String groupId, String userId, String accessToken) async {
    logInfo("User with ID: $userId being removed from group with ID: $groupId on API");

    final groupMemberResponse = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=GroupMember&groupID=$groupId&userID=$userId"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      });

    if (groupMemberResponse.statusCode != 200) {
      logError("Failed to fetch GroupMember for user $userId in group $groupId: ${groupMemberResponse.statusCode}");
      return false;
    }
    final List<dynamic> groupMemberList = json.decode(groupMemberResponse.body);
    if (groupMemberList.isEmpty) {
      logWarning("No GroupMember found for user $userId in group $groupId");
      return false;
    }
    final String groupMemberId = groupMemberList[0]['_id'].toString();
    logInfo("Found GroupMember ID: $groupMemberId for user $userId in group $groupId");
    try {
      final response = await httpClient.delete(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=GroupMember/delete"),
        headers: {
          'Authorization': 'Bearer $accessToken', // <-- Uso del token aquí
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'data':{
            'tableName': 'GroupMember',
            'idColumn': '_id',
            'idValue': groupMemberId,
          }
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      logError("Error removing member from group: $e");
    }
    return false;
  }

  @override
  Future<void> deleteGroup(String id, String accessToken) async {
    logInfo("Deleting group with id: $id from API");
    try {
      final response = await httpClient.delete(
        Uri.parse("$_apiBaseUrl/$_databaseName/delete"),
        headers: {
          'Authorization': 'Bearer $accessToken', // <-- Uso del token aquí
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