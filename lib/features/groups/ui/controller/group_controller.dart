//import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:get/get.dart';
import 'package:flourse/features/groups/domain/use_case/group_usecase.dart';
import 'package:loggy/loggy.dart';

class GroupsController extends GetxController {
  final GroupUseCase groupation;
  GroupsController(this.groupation);

  var groups = <Group>[].obs;

  Future<void> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber
  }) async {
    try {
      final newGroup = await groupation.createGroup(maxMembers: maxMembers, categoryId: categoryId, groupNumber: groupNumber);
      logInfo("Group created successfully: $newGroup");
      await getAllGroups();
    } on Exception catch (e) {
      logError("Error creating group: $e");
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      await groupation.deleteGroup(id);
      logInfo("Group with id $id deleted successfully");
      await getAllGroups();
    } on Exception catch (e) {
      logError("Error deleting group: $e");
    }
  }

  Future<List<Group>> getAllGroups() async {
    final fetchedGroups = await groupation.getAllGroups();
    groups.assignAll(fetchedGroups);
    logInfo("Fetched groups in Controller: ${fetchedGroups.length}");
    return fetchedGroups;
  }

  // Unirse a un grupo
  Future<bool> joinGroup(String groupId, String userId) async {
    final result = await groupation.joinGroup(groupId, userId);
    if (result) {
      logInfo("User $userId joined group $groupId");
    } else {
      logWarning("User $userId could not join group $groupId");
    }
    await getAllGroups();
    return result;
  }

  // Eliminar miembro de un grupo
  Future<bool> removeMemberFromGroup(String groupId, String userId) async {
    final result = await groupation.removeMemberFromGroup(groupId, userId);
    if (result) {
      logInfo("User $userId removed from group $groupId");
    } else {
      logWarning("User $userId could not be removed from group $groupId");
    }
    await getAllGroups();
    return result;
  }

  Future<List<Group>> getGroupById(String id) async {
    try {
      return await groupation.getGroupById(id);
    } catch (e) {
      logError("Error fetching group by ID: $e");
      return [];
    }
  }
}