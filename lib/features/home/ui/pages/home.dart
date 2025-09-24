import 'package:flutter/material.dart';
import 'package:flourse/features/courses/ui/pages/courses.dart';
import 'package:flourse/features/evaluations/ui/pages/evaluations.dart';
import 'package:flourse/features/evaluations/ui/pages/currentevaluation.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';
import 'package:flourse/features/home/ui/widgets/course_action_card.dart';
import 'package:get/get.dart';

import '../../../auth/ui/controller/auth_controller.dart';
import '../../../courses/ui/controller/courses_controller.dart';

class HomePage extends StatelessWidget {
  static const String id = '/home';
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
              } 
              // 🔹 Si es más pequeño → solo el icono
              else {
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
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color.fromARGB(120, 223, 223, 223),
                      child: Text(
                        "👤",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "👋 Bienvenido, ${auth.currentUser.value.name.isNotEmpty ? auth.currentUser.value.name : "User"}",
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
                    highlightColor: Colors.blue.shade100, // efecto azul al presionar
                    onTap: () {
                      Navigator.of(context).pushNamed(CoursesPage.id);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Ver todos",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final filteredCourses = courseCon.userCourses;
              if (filteredCourses.isEmpty) {
                return const Center(
                  child: Text('No hay cursos disponibles.'),
                );
              }
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCourses.length + 1, // +1 para incluir el widget extra
                  itemBuilder: (context, index) {
                    if (index == filteredCourses.length) {
                      return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(16),
                        child: CourseActionCard(),
                      ),
                      );
                    }

                    final course = filteredCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: CourseCard(courseInfo: course),
                      ),
                      ),
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
                    highlightColor: Colors.blue.shade100, // efecto azul al presionar
                    onTap: () {
                      Navigator.of(context).pushNamed(EvaluationsPage.id);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Ver todas",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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

Widget _evaluationItem(BuildContext context, Evaluation evaluation) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentEvaluationPage(evaluation: evaluation),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.assignment, color: Colors.blue),
        ),
        title: Text(
          '${evaluation.title} · ${evaluation.course}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evaluation.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              evaluation.timeRemaining,
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    ),
  );
}
