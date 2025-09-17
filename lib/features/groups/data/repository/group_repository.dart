import 'package:flourse/features/groups/data/datasources/i_group_source.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/features/groups/domain/repositories/i_group_repository.dart';


class GroupRepository implements IGroupRepository {

  late IGroupSource groupSource;

  GroupRepository(this.groupSource);

  @override
  List<Group> getAllGroups() {
    return groupSource.getAllGroups();
  }

  @override
  Group? getGroupById(String id) {
    return groupSource.getGroupById(id);
  }

  @override
  void createGroup({
    required String id,
    required int maxMembers
  }) {
    groupSource.createGroup(
      id: id,
      maxMembers: maxMembers
    );
  }

  @override
  bool joinGroup(String groupId, String userId) {
    return groupSource.joinGroup(groupId, userId);
  }

  @override
  bool removeMemberFromGroup(String groupId, String userId) {
    return groupSource.removeMemberFromGroup(groupId, userId);
  }

  @override
  void deleteGroup(String id) {
    groupSource.deleteGroup(id);
  }


}
