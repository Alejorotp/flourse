import 'package:flourse/features/groups/data/datasources/i_group_source.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';

import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../../../../data/data.dart';


class GroupSourceService implements IGroupSource {
  final http.Client httpClient;

  GroupSourceService({http.Client? client})
    : httpClient = client ?? http.Client();


  @override
  List<Group> getAllGroups() {
    logInfo("Fetching all groups");
    return myGroups;
  }

  @override
  Group? getGroupById(int id) {
    logInfo("Fetching group by id: $id");
    try {
      return myGroups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void createGroup({
    required int id,
    required int maxMembers
  }) {
    logInfo("Creating group with id: $id and maxMembers: $maxMembers");
    final newGroup = Group(
      id: id,
      maxMembers: maxMembers
    );
    myGroups.add(newGroup);
  }

  @override
  void deleteGroup(int id) {
    logInfo("Deleting group with id: $id");
    myGroups.removeWhere((group) => group.id == id);

    for (var category in myCategories) {
      category.groupIDs.remove(id);
    }
  }
}
