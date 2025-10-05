import 'package:flourse/features/categories/domain/repositories/i_category_repository.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/use_case/group_usecase.dart';
import 'package:loggy/loggy.dart';

class CategoryUseCase {
  final ICategoryRepository _repository;
  final GroupUseCase _groupUseCase;

  CategoryUseCase(this._repository, this._groupUseCase);

  Future<List<Category>> getAllCategories() {
    return _repository.getAllCategories();
  }

  Future<void> createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required String courseId,
  }) async {
    await _repository.createCategory(
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );

    // Handle automatic group creation for random grouping method
    if (groupingMethod == 'Aleatorio') {
      await _createRandomGroups(courseId, maxMembers);
    }
  }

  Future<void> _createRandomGroups(String courseId, int maxMembers) async {
    try {
      final membersData = await _repository.getCourseMembers(courseId);
      final memberIds = membersData.map((data) => data['userID'].toString()).toList();
      final groupCount = (memberIds.length / maxMembers).ceil();
      
      for (int i = 0; i < groupCount; i++) {
        final groupMemberIds = memberIds.skip(i * maxMembers).take(maxMembers).toList();
        if (groupMemberIds.isEmpty) break;

        // Get the last created category to get its ID
        final categories = await _repository.getAllCategories();
        final lastCategory = categories.last;
        
        await _groupUseCase.createGroup(
          categoryId: lastCategory.id!,
          groupNumber: i + 1,
          maxMembers: maxMembers,
        );
        
        logInfo("Creating group ${i + 1} with members: $groupMemberIds");
        
        // Get the last created group
        final groups = await _groupUseCase.getAllGroups();
        final lastGroup = groups.last;
        
        for (final member in membersData) {
          if (groupMemberIds.contains(member['userID'].toString()) && member['role'] == false) {
            await _groupUseCase.joinGroup(
              lastGroup.id,
              member['userID'].toString(),
            );
          }
        }
      }
      logInfo("Created $groupCount groups for category with grouping method 'Aleatorio'");
    } catch (e) {
      logError("Error creating random groups: $e");
    }
  }

  void deleteCategory(String id) {
    _repository.deleteCategory(id);
  }

  void updateCategory({
    required String id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  }) {
    _repository.updateCategory(
      id: id,
      newName: newName,
      newGroupingMethod: newGroupingMethod,
      newMaxMembers: newMaxMembers,
    );
  }

  Future<Category?> getCategoryById(String id) {
    return _repository.getCategoryById(id);
  }

  
}
