import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/data/datasources/i_category_source.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'dart:convert';



class CategorySourceService implements ICategorySource {
  final http.Client httpClient;

  AuthenticationController auth = Get.find();

  CategorySourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<List<Category>> getAllCategories() async {
    logInfo("Fetching all categories");
     final responseQuery = await httpClient.get(
          Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=Category"),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        );

    logInfo("Categories fetch response status: ${responseQuery.statusCode}");
    logInfo("Categories fetch response body: ${responseQuery.body}");
    final List<dynamic> responseData = responseQuery.body.isNotEmpty ? json.decode(responseQuery.body) : [];
    return responseData.map((data) => Category(
      id: data['id'].toString(),
      name: data['name'],
      groupingMethod: data['groupingMethod'],
      maxMembers: data['maxMembers'],
      courseId: data['courseId'],
    )).toList();
  }

  @override
  void createCategory({
    required String name,
    required String groupingMethod,
    required int maxMembers,
    required String courseId,
  }) async {
    logInfo("Creating category: $name");
    final newCategory = Category(
      name: name,
      groupingMethod: groupingMethod,
      maxMembers: maxMembers,
      courseId: courseId,
    );

    final responseCreateCategory = await httpClient.post(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/insert"),
      headers: {
        'Authorization': 'Bearer ${auth.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tableName': 'Category',
        'records': [
          {
            'name': newCategory.name,
            'groupingMethod': newCategory.groupingMethod,
            'maxMembers': newCategory.maxMembers,
          },
        ],
      }),
    );

    logInfo("Category creation response status: ${responseCreateCategory.statusCode}");
    logInfo("Category creation response body: ${responseCreateCategory.body}");
    
  }


  @override
  void deleteCategory(String id) async{
    logInfo("Deleting category with id: $id");
     final responseQuery = await httpClient.delete(
          Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=Category/delete}"),
          
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
          body: jsonEncode({
            'data':{
            'tableName': 'Category',
              'idColumn': '_id',
              'id': id
            }
          }),
        
        );
    logInfo("Category deletion response status: ${responseQuery.statusCode}");
    logInfo("Category deletion response body: ${responseQuery.body}");

      final relatedCoursesResponse = await httpClient.delete(
          Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=CourseCategory/delete"),
          headers: {
            'Authorization':'Bearer ${auth.accessToken}',
          },
          body: jsonEncode({
            'data':{
            'tableName': 'CourseCategory',
              'columnName': 'categoryID',
              'value': id
            }
          }),
        );
    logInfo("Related CourseCategory deletion response status: ${relatedCoursesResponse.statusCode}");
    logInfo("Related CourseCategory deletion response body: ${relatedCoursesResponse.body}");
  }


  @override
  void updateCategory ({
    required String id,
    String? newName,
    String? newGroupingMethod,
    int? newMaxMembers,
  }) async {
    logInfo("Updating category with id: $id");
    
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    logInfo("Fetching category by id: $id");
    final response = await httpClient.put(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=Category&_id=$id"),
      headers: {
        'Authorization' : 'Bearer ${auth.accessToken}',
      },
    );
    logInfo("Fetch category by id response status: ${response.statusCode}");
    logInfo("Fetch category by id response body: ${response.body}");

      
    final Map<String, dynamic> responseData = response.body.isNotEmpty ? json.decode(response.body) : {};
    if (responseData.isEmpty) {
      return null;
    }

    return Category(
      id: responseData['id'].toString(),
      name: responseData['name'],
      groupingMethod: responseData['groupingMethod'],
      maxMembers: responseData['maxMembers'],
      courseId: responseData['courseId'],
    );
    }

}
