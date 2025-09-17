import '../models/groups.dart';

abstract class IGroupRepository {
  Future<List<Group>> getAllGroups();

  Future<Group?> getGroupById(String id);

  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber
  });

  Future<bool> joinGroup(String groupId, String userId);

  Future<bool> removeMemberFromGroup(String groupId, String userId);

  Future<void> deleteGroup(String id);
}