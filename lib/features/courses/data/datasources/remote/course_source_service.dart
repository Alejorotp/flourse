import 'dart:math';

import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../domain/models/course.dart';
import '../../../domain/models/course_info.dart';
import '../i_course_source.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'dart:convert';

class CourseSourceService implements ICourseSource {
  final http.Client httpClient;

  final String _databaseName = "flourse_460df99409";
  final String _apiBaseUrl = "https://roble-api.openlab.uninorte.edu.co/database";

  final AuthenticationController authController = Get.find();

  String get _authToken => authController.accessToken.value;

  CourseSourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<String> getUserNameById(String userId) async {
    logInfo("Fetching user name for userId: $userId");
    try {
      final response = await httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=AuthenticationUser&UID=$userId"),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final user = jsonList.isNotEmpty ? jsonList.first : [];
        logInfo("Fetched user name: ${user?['name']}");
        return Future.value(user?['name'] ?? "Usuario Desconocido");
      } else {
        logError("Failed to fetch user name: ${response.statusCode}");
        return Future.value("Usuario Desconocido");
      }
    } catch (e) {
      logError("Error fetching user name: $e");
      return Future.value("Usuario Desconocido");
    }
  }

  @override
  Future<List<UserCourseInfo>> getCourseInfo(String? userId) async {
    logInfo("Fetching course info for all courses related to userId: $userId");

    final responseCourseMember = await httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=CourseMember&userID=$userId"),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );

    if (responseCourseMember.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(responseCourseMember.body);
      final memberCourseIds = jsonList.map((json) => json['courseID'] as String).toList();
      logInfo("User is member of courses: $memberCourseIds");

    if (memberCourseIds.isEmpty) {
      logInfo("User is not a member of any course.");
      return [];
    }

    // I need to standarize it mapping it, to not get only one course, so map it to use multiple api calls, each giving you a response
    final responseCourses = await Future.wait(memberCourseIds.map((courseId) {
      return httpClient.get(
        Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Course&_id=$courseId"),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );
    }));
      logInfo("Fetched course details for user: ${responseCourses.length} responses");
      if (responseCourses.isEmpty) {
        logInfo("No course details found for the user's courses.");
        return [];
      }
    if (responseCourses.isNotEmpty) {
      // Flatten all course responses into a single list of course JSONs
      final List<dynamic> allCoursesJson = responseCourses
          .map((response) => json.decode(response.body))
          .expand((jsonList) => jsonList)
          .toList();

      final coursesFutures = allCoursesJson.map<Future<UserCourseInfo>>((json) async {
        final course = Course.fromJson(json);
        final userRole = course.professorID == userId ? "Profesor" : "Estudiante";
        final professorName = await getUserNameById(course.professorID);
        final memberNamesFutures = (course.memberIDs ?? []).map((id) => getUserNameById(id)).toList();
        final memberNames = await Future.wait(memberNamesFutures);

        return UserCourseInfo(
          course: course,
          userRole: userRole,
          professorName: professorName,
          memberNames: memberNames,
        );
      }).toList();
      return Future.wait(coursesFutures);
    } else {
      logError("Failed to fetch courses: No responses received");
      return [];
    }
    } else {
      logError("Failed to fetch course members: ${responseCourseMember.statusCode}, body: ${responseCourseMember.body}");
      return [];
    }
  }

  @override
  Future<List<UserCourseInfo>> getAllCourses() async {
    logInfo("Fetching all courses");
    final response = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Course"),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final coursesFutures = jsonList.map((json) async {
        final memberIDs = json['memberIDs'] as List<dynamic>? ?? [];
        final memberNamesFutures = memberIDs.map((id) => getUserNameById(id as String)).toList();
        final memberNames = await Future.wait(memberNamesFutures);
        final professorNameFuture = getUserNameById(json['professorID'] as String);
        final professorName = await professorNameFuture;
        final course = Course.fromJson(json);
        return UserCourseInfo(
          course: course,
          userRole: '',
          professorName: professorName,
          memberNames: memberNames,
        );
      }).toList();
      logInfo("Total courses fetched: ${coursesFutures.length}");
      if (coursesFutures.isNotEmpty) {
        final firstCourseInfo = await coursesFutures[0];
        logInfo("First course details: ${firstCourseInfo.course}, ${firstCourseInfo.professorName}");
      }
      return Future.wait(coursesFutures);
    } else {
      logError("Failed to fetch courses: ${response.statusCode}");
      return [];
    }
  }

  @override
  Future<void> createCourse({
    required String title,
    required String professorID,
  }) async {
    logInfo("Creating course with title: $title for professorID: $professorID");

    Future<String> generateUniqueCourseCode() async {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234S6789';
      final rand = Random();
      String courseCode;
      bool isUnique = false;

      while (!isUnique) {
        courseCode = List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
        logInfo("Generated course code: $courseCode");

        final response = await httpClient.get(
          Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Course&courseCode='$courseCode'"),
          headers: {'Authorization': 'Bearer $_authToken'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isEmpty) {
            isUnique = true;
            logInfo("Course code is unique.");
            return courseCode;
          } else {
            logWarning("Course code already exists. Regenerating...");
          }
        } else {
          logError("Error checking for course code uniqueness: ${response.statusCode}");
          // Stop if there's a server error to avoid an infinite loop
          throw Exception('Failed to verify course code uniqueness');
        }
      }
      // This part should not be reachable due to the return inside the loop
      throw Exception('Failed to generate a unique course code');
    }

    final code = await generateUniqueCourseCode();
    final newCourse = Course(
      title: title,
      courseCode: code,
      professorID: professorID,
      memberIDs: [],
      categoryIDs: [],
    );

    final response = await httpClient.post(
      Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: json.encode({
        "tableName": "Course",
        "records": [
          {
            "title": newCourse.title,
            "courseCode": newCourse.courseCode,
            "professorID": newCourse.professorID,
          }
        ],
      }),
    );

    if (response.statusCode != 201) {
      logError("Failed to create course: ${response.statusCode} ${response.body}");
      throw Exception('Failed to create course');
    }

    logInfo("Successfully created course with code $code");
    // Add the user as a member of the course
    await joinCourse(courseCode: code, userId: professorID);  
  }

  @override
  Future<bool> joinCourse({required String courseCode, required String userId}) async {
    logInfo("User with ID: $userId joining course with code: $courseCode");

    // Find the course by courseCode
    final courseResponse = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=Course&courseCode=$courseCode"),
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    if (courseResponse.statusCode != 200) {
      logError("Failed to fetch course: ${courseResponse.statusCode}");
      return false;
    }

    final List<dynamic> courseData = json.decode(courseResponse.body);
    if (courseData.isEmpty) {
      logWarning("Course with code $courseCode not found");
      return false;
    }

    final courseId = courseData.first['_id'];

    // Check if the user is already a member
    final memberCheckResponse = await httpClient.get(
      Uri.parse("$_apiBaseUrl/$_databaseName/read?tableName=CourseMember&userID=$userId&courseID=$courseId"),
      headers: {'Authorization': 'Bearer $_authToken'},
    );

    if (memberCheckResponse.statusCode == 200) {
      final List<dynamic> memberData = json.decode(memberCheckResponse.body);
      if (memberData.isNotEmpty) {
        logWarning("User with ID: $userId is already a member of the course");
        return false;
      }
    } else {
      logError("Failed to check course membership: ${memberCheckResponse.statusCode}, body: ${memberCheckResponse.body}");
      return false;
    }

    // If not a member, add the user to the CourseMember table
    final joinResponse = await httpClient.post(
      Uri.parse("$_apiBaseUrl/$_databaseName/insert"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
      body: json.encode({
        "tableName": "CourseMember",
        "records": [{"courseID": courseId, "userID": userId}],
      }),
    );

    if (joinResponse.statusCode == 201) {
      logInfo("User with ID: $userId successfully joined course with code $courseCode");
      return true;
    } else {
      logError("Failed to join course: ${joinResponse.statusCode} ${joinResponse.body}");
      return false;
    }
  }
}
