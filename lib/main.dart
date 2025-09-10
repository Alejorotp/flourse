import 'package:flourse/features/auth/data/datasources/local/authentication_source_service.dart';
import 'package:flourse/features/auth/ui/pages/login.dart';
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

void main() {
  Loggy.initLoggy(logPrinter: const PrettyPrinter(showColors: true));

  Get.put(http.Client()); // Iniciar el cliente HTTP

  // Auth
  Get.put<IAuthenticationSource>(AuthenticationSourceService());
  Get.put<IAuthRepository>(AuthRepository(Get.find()));
  Get.put(AuthenticationUseCase(Get.find()));
  Get.put(AuthenticationController(Get.find()));

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
      }
    );
  }
}
