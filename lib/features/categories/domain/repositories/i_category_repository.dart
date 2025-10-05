import 'package:flourse/features/categories/domain/models/category.dart';


abstract class ICategoryRepository {
  Future<List<Category>> getAllCategories();

  Future<void> createCategory({
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

  Future<Category?> getCategoryById(String id);

  Future<List<Map<String, dynamic>>> getCourseMembers(String courseId);
}
