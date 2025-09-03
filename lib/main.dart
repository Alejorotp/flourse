import 'package:flourse/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/domain/use_case/auth_controller.dart';
import 'package:flourse/presentation/pages/home.dart';
import 'package:flourse/presentation/pages/courses.dart';
import 'package:flourse/presentation/pages/evaluations.dart';

void main() {
  Get.put(AuthController()); // Iniciar el controlador de autenticación
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData('data'),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (_) => const LoginPage(),
        HomePage.id: (_) => const HomePage(),
        CoursesPage.id: (_) => const CoursesPage(),
        EvaluationsPage.id: (_) => const EvaluationsPage(),
      },
    );
  }
}
