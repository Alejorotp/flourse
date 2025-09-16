import 'package:flourse/features/categories/data/datasources/i_category_source.dart';
import 'package:flourse/features/categories/domain/repositories/i_category_repository.dart';
import 'package:flourse/features/categories/domain/models/category.dart';


class CategoryRepository implements ICategoryRepository {
  late ICategorySource categorySource;

  CategoryRepository(this.categorySource);

  @override
  List<Category> getAllCategories() {
    return categorySource.getAllCategories();
  }

  @override
  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required int courseId,
  }) {
    return categorySource.createCategory(
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );
  }

  @override
  void deleteCategory(int id) {
    return categorySource.deleteCategory(id);
  }

  @override
  void updateCategory({
    required int id,
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
  Category? getCategoryById(int id) {
    return categorySource.getCategoryById(id);
  }



  

  


}
