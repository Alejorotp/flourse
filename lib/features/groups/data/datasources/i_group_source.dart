import 'package:flourse/features/groups/domain/models/groups.dart';

abstract class IGroupSource {
  Future<List<Group>> getAllGroups(String accessToken);

  Future<List<Group>> getGroupById(String id, String accessToken);

  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber,
    required String accessToken
  });

  Future<bool> joinGroup(String groupId, String userId, String accessToken);

  Future<bool> removeMemberFromGroup(String groupId, String userId, String accessToken);

  Future<void> deleteGroup(String id, String accessToken);
}