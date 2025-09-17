import '../models/groups.dart';


abstract class IGroupRepository {

  List<Group> getAllGroups();

  Group? getGroupById(String id);

  void createGroup({
    required String id,
    required int maxMembers
  });

  bool joinGroup(String groupId, String userId);

  bool removeMemberFromGroup(String groupId, String userId);

  void deleteGroup(String id);


}
