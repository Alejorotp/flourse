import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/courses/domain/models/course.dart';
import 'package:flourse/data/data.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/use_case/category_usecase.dart';


class CategoriesController extends GetxController{
  final CategoryUseCase categoryation;
  CategoriesController(this.categoryation);

  final List<Category> categories = myCategories;

  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required Course course,
  }) {
    categoryation.createCategory(name: name, groupingMethod: groupingMethod, maxMembers: maxMembers, courseId: course.courseCode);
  }

  void deleteCategory(String id) {
    categories.removeWhere((category) => category.id == id);

    for (var course in myCourses) {
      course.categoryIDs.remove(id);
    }
  }

  void updateCategory({
    required String id,
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
        courseId: category.courseId,
      );
    }
  }

  List<Category> getAllCategories() {
    return categories;
  }

  String getCategoryNameById(String id) {
    final category = categories.firstWhere(
      (category) => category.id == id,
      orElse: () => Category(
        id: '0',
        name: 'Desconocida',
        groupingMethod: 'N/A',
        maxMembers: 0,
        courseId: 'N/A',
      ),
    );
    return category.name;
  }

  Category? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id.toString() == id);
    } catch (e) {
      return null;
    }
  }
}
