import 'package:flourse/features/auth/data/datasources/local/authentication_source_service.dart';
import 'package:flourse/features/auth/ui/pages/login.dart';
import 'package:flourse/features/courses/ui/pages/joinCourse.dart';
import 'package:flourse/features/home/ui/pages/home.dart';
import 'package:flourse/features/courses/ui/pages/courses.dart';
import 'package:flourse/features/courses/ui/pages/createCourse.dart';
import 'package:flourse/features/evaluations/ui/pages/evaluations.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

import 'central.dart';

import 'features/auth/data/datasources/local/i_authentication_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/i_auth_repository.dart';
import 'features/auth/domain/use_case/authentication_usecase.dart';
import 'features/auth/ui/controller/auth_controller.dart';


import 'features/courses/data/datasources/local/i_course_source.dart';
import 'features/courses/data/datasources/local/course_source_service.dart';
import 'features/courses/data/repository/course_repository.dart';
import 'features/courses/domain/repositories/i_course_repository.dart';
import 'features/courses/domain/use_case/course_usecase.dart';
import 'features/courses/ui/controller/courses_controller.dart';


void main() {
  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));

  Get.put(http.Client()); // Iniciar el cliente HTTP

  // Auth
  Get.put<IAuthenticationSource>(AuthenticationSourceService());
  Get.put<IAuthRepository>(AuthRepository(Get.find()));
  Get.put(AuthenticationUseCase(Get.find()));
  Get.put(AuthenticationController(Get.find()));

  // Courses
  Get.put<ICourseSource>(CourseSourceService());
  Get.put<ICourseRepository>(CourseRepository(Get.find()));
  Get.put(CourseUseCase(Get.find()));
  Get.put(CoursesController(Get.find()));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clean template',
      debugShowCheckedModeBanner: false,
      home: const Central(),
      routes:{
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/courses': (context) => CoursesPage(),
        '/evaluations': (context) => EvaluationsPage(),
        '/create-course': (context) => CreateCoursePage(),
        '/join-course': (context) => JoinCoursePage(),
      }
    );
  }
}
