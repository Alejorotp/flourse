import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/data/datasources/i_category_source.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'dart:convert';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';



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
      id: data['_id'].toString(),
      name: data['name'],
      groupingMethod: data['groupingMethod'],
      maxMembers: data['maxMembers'],
      courseId: data['courseID'],
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
            'courseID': newCategory.courseId,
          },
        ],
      }),
    );

    logInfo("Category creation response status: ${responseCreateCategory.statusCode}");
    logInfo("Category creation response body: ${responseCreateCategory.body}");

    if (groupingMethod == 'Aleatorio'){
      GroupsController groupsController = Get.find();
      final courseMembersResponse = await httpClient.get(
        Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=CourseMember&courseID=$courseId"),
        headers: {
          'Authorization': 'Bearer ${auth.accessToken}',
        },
      );
      logInfo("Course members fetch response status: ${courseMembersResponse.statusCode}");
      logInfo("Course members fetch response body: ${courseMembersResponse.body}");
      final List<dynamic> membersData = courseMembersResponse.body.isNotEmpty ? json.decode(courseMembersResponse.body) : [];
      final memberIds = membersData.map((data) => data['userID'].toString()).toList();
      final groupCount = (memberIds.length / maxMembers).ceil();
      for (int i = 0; i < groupCount; i++) {
        final groupMemberIds = memberIds.skip(i * maxMembers).take(maxMembers).toList();
        if (groupMemberIds.isEmpty) break;

        groupsController.createGroup(
          categoryId: newCategory.id!,
          groupNumber: i + 1,
          maxMembers: newCategory.maxMembers,
        );
        logInfo("Creating group ${i + 1} with members: $groupMemberIds");

        groupMemberIds.forEach((memberId) {
          groupsController.joinGroup(
            groupsController.groups.last.id,
            memberId,
          );
          logInfo("Added member $memberId to group ${groupsController.groups.last.id}");
        });

        


      }
      logInfo("Created $groupCount groups for category ${newCategory.name} with grouping method 'Aleatorio'");
    }
    
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
              'idValue': id
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
              'idColumn': 'categoryID',
              'idValue': id
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
    final response = await httpClient.get(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=Category&courseID=$id"),
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
      courseId: responseData['courseID'],
    );
    }

}
