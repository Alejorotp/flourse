import '../models/groups.dart';


abstract class IGroupRepository {

  List<Group> getAllGroups();

  Group? getGroupById(int id);

  void createGroup({
    required int id,
    required int maxMembers
  });

  bool joinGroup(int groupId, int userId);

  bool removeMemberFromGroup(int groupId, int userId);

  void deleteGroup(int id);
  

}
