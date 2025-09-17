import 'package:flourse/features/categories/data/datasources/i_category_source.dart';
import 'package:flourse/features/categories/domain/repositories/i_category_repository.dart';
import 'package:flourse/features/categories/domain/models/category.dart';


class CategoryRepository implements ICategoryRepository {
  late ICategorySource categorySource;

  CategoryRepository(this.categorySource);

  @override
  Future<List<Category>> getAllCategories() {
    return categorySource.getAllCategories();
  }

  @override
  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required String courseId,
  }) {
      categorySource.createCategory(
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );
  }

  @override
  void deleteCategory(String id) {
    return categorySource.deleteCategory(id);
  }

  @override
  void updateCategory({
    required String id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  }) {
    return categorySource.updateCategory(
      id: id,
      newName: newName,
      newGroupingMethod: newGroupingMethod,
      newMaxMembers: newMaxMembers,
    );
  }

  @override
  Future<Category?> getCategoryById(String id) {
    return categorySource.getCategoryById(id);
  }



  

  


}
