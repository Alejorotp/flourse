import 'package:flourse/features/groups/domain/models/groups.dart';
import '../repositories/i_group_repository.dart';

class GroupUseCase {
  final IGroupRepository _repository;

  GroupUseCase(this._repository);

  Future<List<Group>> getAllGroups({required String categoryId}) {
    return _repository.getAllGroups(categoryId: categoryId);
  }

  Future<List<Group>> getGroupById(String id) {
    return _repository.getGroupById(id);
  }

  Future<Group> createGroup({
    required int maxMembers,
    required String categoryId,
    required int groupNumber,
  }) {
    return _repository.createGroup(
      maxMembers: maxMembers,
      categoryId: categoryId,
      groupNumber: groupNumber,
    );
  }

  Future<bool> joinGroup(String groupId, String userId) {
    return _repository.joinGroup(groupId, userId);
  }

  Future<bool> removeMemberFromGroup(String groupId, String userId) {
    return _repository.removeMemberFromGroup(groupId, userId);
  }

  Future<void> deleteGroup(String id) {
    return _repository.deleteGroup(id);
  }

  Future<List<Group>> getUserGroups(String userId) {
    return _repository.getUserGroups(userId);
  }
}