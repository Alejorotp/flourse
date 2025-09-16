import '../../domain/models/category.dart';



abstract class ICategorySource {

  List<Category> getAllCategories();

  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required int courseId,
  });

  void deleteCategory(int id);

  void updateCategory({
    required int id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  });

  Category? getCategoryById(int id);


}
