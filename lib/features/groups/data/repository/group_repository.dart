import 'package:flourse/features/groups/data/datasources/i_group_source.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/features/groups/domain/repositories/i_group_repository.dart';


class GroupRepository implements IGroupRepository {
  late IGroupSource groupSource;

  GroupRepository(this.groupSource);

  @override
  Future<List<Group>> getAllGroups() {
    return groupSource.getAllGroups();
  }

  @override
  Future<Group?> getGroupById(String id) {
    return groupSource.getGroupById(id);
  }

  @override
  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber
  }) {
    return groupSource.createGroup(
      maxMembers: maxMembers,
      categoryId: categoryId,
      groupNumber: groupNumber,
    );
  }

  @override
  Future<bool> joinGroup(String groupId, String userId) {
    return groupSource.joinGroup(groupId, userId);
  }

  @override
  Future<bool> removeMemberFromGroup(String groupId, String userId) {
    return groupSource.removeMemberFromGroup(groupId, userId);
  }

  @override
  Future<void> deleteGroup(String id) {
    return groupSource.deleteGroup(id);
  }
}