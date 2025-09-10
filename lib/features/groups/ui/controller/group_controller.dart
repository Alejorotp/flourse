import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/data/data.dart';

class GroupsController {
  static final GroupsController _instance =
      GroupsController._internal();
  factory GroupsController() => _instance;
  GroupsController._internal();

  final List<Group> groups = myGroups;

  void createGroup({
    required int id,
    required int maxMembers
  }) {
    final newGroup = Group(
      id: groups.length + 1,
      maxMembers: maxMembers
    );
    myGroups.add(newGroup);
  }

  void deleteGroup(int id) {
    groups.removeWhere((group) => group.id == id);

    for (var category in myCategories) {
      category.groupIDs.remove(id);
    }
  }


  List<Group> getAllGroups() {
    return myGroups;
  }

  Group? getGroupById(int id) {
    try {
      return myGroups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }
}
