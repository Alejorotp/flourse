
import 'package:flourse/features/groups/domain/models/groups.dart';

abstract class IGroupSource {

  List<Group> getAllGroups();

  Group? getGroupById(int id);

  void createGroup({
    required int id,
    required int maxMembers
  });

  void deleteGroup(int id);

}
