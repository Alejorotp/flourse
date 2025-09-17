import 'package:flourse/features/groups/domain/models/groups.dart';
import '../repositories/i_group_repository.dart';



class GroupUseCase {

  final IGroupRepository _repository;

  GroupUseCase(this._repository);

  List<Group> getAllGroups() {
    return _repository.getAllGroups();
  }

  Group? getGroupById(String id) {
    return _repository.getGroupById(id);
  }

  void createGroup({
    required String id,
    required int maxMembers
  }) {
    _repository.createGroup(
      id: id,
      maxMembers: maxMembers
    );
  }

  bool joinGroup(String groupId, String userId) {
    return _repository.joinGroup(groupId, userId);
  }

  bool removeMemberFromGroup(String groupId, String userId) {
    return _repository.removeMemberFromGroup(groupId, userId);
  }

  void deleteGroup(String id) {
    _repository.deleteGroup(id);
  }
  
}
