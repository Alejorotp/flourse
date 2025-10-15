//import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:get/get.dart';
import 'package:flourse/features/groups/domain/use_case/group_usecase.dart';
import 'package:loggy/loggy.dart';

class GroupsController extends GetxController {
  final GroupUseCase groupation;
  GroupsController(this.groupation);

  var groups = <Group>[].obs;
  var userGroups = <Group>[].obs;

  Future<void> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber
  }) async {
    try {
      final newGroup = await groupation.createGroup(maxMembers: maxMembers, categoryId: categoryId, groupNumber: groupNumber);
      logInfo("Group created successfully: $newGroup");
      await getAllGroups(categoryId: categoryId);
    } on Exception catch (e) {
      logError("Error creating group: $e");
    }
  }

  Future<void> deleteGroup(String id, String categoryId) async {
    try {
      await groupation.deleteGroup(id);
      logInfo("Group with id $id deleted successfully");
      await getAllGroups(categoryId: categoryId);
    } on Exception catch (e) {
      logError("Error deleting group: $e");
    }
  }

  Future<List<Group>> getAllGroups({required String categoryId}) async {
    final fetchedGroups = await groupation.getAllGroups(categoryId: categoryId);
    groups.assignAll(fetchedGroups);
    logInfo("Fetched groups in Controller: ${fetchedGroups.length}, details: $fetchedGroups");
    return fetchedGroups;
  }

  // Unirse a un grupo
  Future<bool> joinGroup(String groupId, String userId, String categoryId) async {
    final result = await groupation.joinGroup(groupId, userId);
    if (result) {
      logInfo("User $userId joined group $groupId");
    } else {
      logWarning("User $userId could not join group $groupId");
    }
    await getAllGroups(categoryId: categoryId);
    return result;
  }

  // Eliminar miembro de un grupo
  Future<bool> removeMemberFromGroup(String groupId, String userId, String categoryId) async {
    final result = await groupation.removeMemberFromGroup(groupId, userId);
    if (result) {
      logInfo("User $userId removed from group $groupId");
    } else {
      logWarning("User $userId could not be removed from group $groupId");
    }
    await getAllGroups(categoryId: categoryId);
    return result;
  }

  Future<List<Group>> getGroupById(String id) async {
    try {
      final fetchedGroups = await groupation.getGroupById(id);
      groups.assignAll(fetchedGroups);
      return fetchedGroups;

    } catch (e) {
      logError("Error fetching group by ID: $e");
      return [];
    }
  }

  Future<List<Group>> getUserGroups(String userId) async {
    try {
      final userGroups = await groupation.getUserGroups(userId);
      logInfo("Fetched groups for user ID: $userId");
      this.userGroups.assignAll(userGroups);
      return userGroups;
    } catch (e) {
      logError("Error fetching user groups: $e");
    }
    return [];
  }
}