import 'package:flourse/features/categories/domain/repositories/i_category_repository.dart';
import 'package:flourse/features/categories/domain/models/category.dart';

class CategoryUseCase {
  final ICategoryRepository _repository;

  CategoryUseCase(this._repository);

  List<Category> getAllCategories() {
    return _repository.getAllCategories();
  }

  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required int courseId,
  }) {
    _repository.createCategory(
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );
  }

  void deleteCategory(int id) {
    _repository.deleteCategory(id);
  }

  void updateCategory({
    required int id,
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

  Category? getCategoryById(int id) {
    return _repository.getCategoryById(id);
  }

  
}
