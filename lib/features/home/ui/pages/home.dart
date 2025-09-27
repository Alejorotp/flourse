import 'package:flutter/material.dart';
import 'package:flourse/features/courses/ui/pages/courses.dart';
import 'package:flourse/features/evaluations/ui/pages/evaluations.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';
import 'package:flourse/features/home/ui/widgets/create_course_card.dart';
import 'package:flourse/features/home/ui/widgets/join_course_card.dart';
import 'package:get/get.dart';

import '../../../auth/ui/controller/auth_controller.dart';
import '../../../courses/ui/controller/courses_controller.dart';

class HomePage extends StatelessWidget {
  static const String id = '/home';
  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  static const blue = Color.fromRGBO(43, 213, 243, 1); // celeste
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();
    CoursesController courseCon = Get.find();
    courseCon.loadUserCourses(auth.currentUser.value.id ?? "0");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(50, 239, 229, 248),
        automaticallyImplyLeading: false,
        title: const Text(
          "Flourse",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              double width = MediaQuery.of(context).size.width;
              if (width >= 700) {
                return TextButton.icon(
                  onPressed: () async {
                    await auth.logOut();
                  },
                  icon: const Icon(Icons.logout, color: Colors.black87, size: 22),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () async {
                    await auth.logOut();
                  },
                  icon: const Icon(Icons.logout, color: Colors.black87, size: 22),
                );
              }
            },
          ),
          const SizedBox(width: 2),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida con card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color.fromARGB(120, 223, 223, 223),
                      child: Text(
                        (auth.currentUser.value.name.isNotEmpty
                                ? auth.currentUser.value.name[0]
                                : 'U')
                            .toUpperCase(),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "👋 Bienvenido, ${auth.currentUser.value.name.isNotEmpty ? auth.currentUser.value.name : 'User'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 0.15, color: Colors.grey),
            // Mis cursos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mis cursos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    highlightColor: Colors.blue.shade100,
                    onTap: () {
                      Navigator.of(context).pushNamed(CoursesPage.id);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Ver todos",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Etiqueta Profesor
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(40, 124, 77, 255), // fondo lilac suave
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school, color: lilac, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Profesor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lilac,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Carrusel de profesor
            Obx(() {
              final profCourses = courseCon.userCourses.where((c) => c.userRole.toLowerCase() == 'profesor').toList();
              final showCreate = profCourses.length <= 2;
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: profCourses.length + (showCreate ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showCreate && index == profCourses.length) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CreateCourseCard(
                          onTap: () => Get.toNamed("/create-course"),
                        ),
                      );
                    }
                    final course = profCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CourseCard(courseInfo: course),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 12),
            // Etiqueta Estudiante
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(40, 43, 213, 243), // fondo azul suave
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Color.fromARGB(255, 0, 124, 182), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Estudiante',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 124, 182),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Carrusel de estudiante
            Obx(() {
              final studentCourses = courseCon.userCourses.where((c) => c.userRole.toLowerCase() == 'estudiante').toList();
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: studentCourses.length + 1, // +1 para card de unirse
                  itemBuilder: (context, index) {
                    if (index == studentCourses.length) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: JoinCourseCard(
                          onTap: () => Get.toNamed("/join-course"),
                        ),
                      );
                    }
                    final course = studentCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CourseCard(courseInfo: course),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
            // Evaluaciones pendientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Evaluaciones pendientes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    highlightColor: Colors.blue.shade100,
                    onTap: () {
                      Navigator.of(context).pushNamed(EvaluationsPage.id);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Ver todos",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
