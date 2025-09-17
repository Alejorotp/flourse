import 'package:flourse/features/categories/domain/models/category.dart';


abstract class ICategoryRepository {
  List<Category> getAllCategories();

  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required String courseId,
  });

  void deleteCategory(String id);

  void updateCategory({
    required String id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  });

  Category? getCategoryById(String id);
}
