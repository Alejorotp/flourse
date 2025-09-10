import '../models/groups.dart';


abstract class IGroupRepository {

  List<Group> getAllGroups();

  Group? getGroupById(int id);

  void createGroup({
    required int id,
    required int maxMembers
  });

  void deleteGroup(int id);
  

}
