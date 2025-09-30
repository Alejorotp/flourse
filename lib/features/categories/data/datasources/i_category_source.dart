import '../../domain/models/category.dart';



abstract class ICategorySource {

  Future<List<Category>> getAllCategories();

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

  Future<Category?> getCategoryById(String id);


}
