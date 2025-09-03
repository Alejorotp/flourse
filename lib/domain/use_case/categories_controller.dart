import 'package:flourse/domain/models/category.dart';
import 'package:flourse/domain/models/course.dart';
import 'package:flourse/data/data.dart';

class CategoriesController {
  static final CategoriesController _instance =
      CategoriesController._internal();
  factory CategoriesController() => _instance;
  CategoriesController._internal();

  final List<Category> categories = myCategories;

  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required Course course,
  }) {
    final newCategory = Category(
      id: categories.length + 1,
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
    );
    categories.add(newCategory);
    course.categoryIDs.add(newCategory.id);
  }

  void deleteCategory(int id) {
    categories.removeWhere((category) => category.id == id);

    for (var course in myCourses) {
      course.categoryIDs.remove(id);
    }
  }

  void updateCategory({
    required int id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  }) {
    final index = categories.indexWhere((category) => category.id == id);
    if (index != -1) {
      final category = categories[index];
      categories[index] = Category(
        id: category.id,
        name: newName ?? category.name,
        groupingMethod: newGroupingMethod ?? category.groupingMethod,
        maxMembers: newMaxMembers ?? category.maxMembers,
      );
    }
  }

  List<Category> getAllCategories() {
    return categories;
  }

  String getCategoryNameById(int id) {
    final category = categories.firstWhere(
      (category) => category.id == id,
      orElse: () => Category(
        id: 0,
        name: 'Desconocida',
        groupingMethod: 'N/A',
        maxMembers: 0,
      ),
    );
    return category.name;
  }

  Category? getCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
