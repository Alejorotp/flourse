import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../../../../data/data.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/data/datasources/i_category_source.dart';


class CategorySourceService implements ICategorySource {
  final http.Client httpClient;

  CategorySourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  List<Category> getAllCategories() {
    logInfo("Fetching all categories");
    return myCategories;
  }

  @override
  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required int courseId,
  }) {
    logInfo("Creating category: $name");
    final newCategory = Category(
      id: myCategories.isNotEmpty ? myCategories.last.id + 1 : 1,
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
    );
    myCategories.add(newCategory);
  }
  @override
  void deleteCategory(int id) {
    logInfo("Deleting category with id: $id");
    myCategories.removeWhere((category) => category.id == id);

    for (var course in myCourses) {
      course.categoryIDs.remove(id);
    }
  }


  @override
  void updateCategory({
    required int id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  }) {
    logInfo("Updating category with id: $id");
    final index = myCategories.indexWhere((category) => category.id == id);
    if (index != -1) {
      final category = myCategories[index];
      myCategories[index] = Category(
        id: category.id,
        name: newName ?? category.name,
        groupingMethod: newGroupingMethod ?? category.groupingMethod,
        maxMembers: newMaxMembers ?? category.maxMembers
      );
    }
  }
  @override
  Category? getCategoryById(int id) {
    logInfo("Fetching category by id: $id");
    try {
      return myCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }


}
