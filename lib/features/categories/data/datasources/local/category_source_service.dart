import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../data/data.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/data/datasources/i_category_source.dart';


class CategorySourceService implements ICategorySource {
  final http.Client httpClient;

  CategorySourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<List<Category>> getAllCategories() async {
    logInfo("Fetching all categories");
    return myCategories;
  }

  @override
  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required String courseId,
  }) {
    logInfo("Creating category: $name");
    final newCategory = Category(
      id: (myCategories.isNotEmpty ? (int.tryParse(myCategories.last.id.toString()) ?? 0) + 1 : 1).toString(),
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );
    myCategories.add(newCategory);
  }

  @override
  void deleteCategory(String id) {
    logInfo("Deleting category with id: $id");
    myCategories.removeWhere((category) => category.id == id);

    for (var course in myCourses) {
      course.categoryIDs.remove(id);
    }
  }


  @override
  void updateCategory({
    required String id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
    String? newCourseId,
  }) {
    logInfo("Updating category with id: $id");
    final index = myCategories.indexWhere((category) => category.id == id);
    if (index != -1) {
      final category = myCategories[index];
      myCategories[index] = Category(
        id: category.id,
        name: newName ?? category.name,
        groupingMethod: newGroupingMethod ?? category.groupingMethod,
        maxMembers: newMaxMembers ?? category.maxMembers,
        courseId: newCourseId ?? category.courseId,
      );
    }
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    logInfo("Fetching category by id: $id");
    try {
      return myCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }


}
