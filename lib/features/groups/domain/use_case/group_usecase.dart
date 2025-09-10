import 'package:flourse/features/groups/domain/models/groups.dart';
import '../repositories/i_group_repository.dart';



class GroupUseCase {

  final IGroupRepository _repository;

  GroupUseCase(this._repository);

  List<Group> getAllGroups() {
    return _repository.getAllGroups();
  }

  Group? getGroupById(int id) {
    return _repository.getGroupById(id);
  }

  void createGroup({
    required int id,
    required int maxMembers
  }) {
    _repository.createGroup(
      id: id,
      maxMembers: maxMembers
    );
  }

  bool joinGroup(int groupId, int userId) {
    return _repository.joinGroup(groupId, userId);
  }

  bool removeMemberFromGroup(int groupId, int userId) {
    return _repository.removeMemberFromGroup(groupId, userId);
  }

  void deleteGroup(int id) {
    _repository.deleteGroup(id);
  }
  
}
