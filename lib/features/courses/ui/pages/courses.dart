import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';
import 'package:flourse/features/courses/ui/widgets/RoleToggleButtons.dart';
import 'package:flourse/features/courses/ui/widgets/create_course_dialog.dart';
import 'package:flourse/features/courses/ui/widgets/join_course_dialog.dart';
import 'dart:ui';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  static const blue = Color.fromRGBO(43, 213, 243, 1); // celeste
  bool _isProfessor = true;

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();
    CoursesController courseCon = Get.find();
    // Cargar cursos del usuario (solo una vez por build)
    courseCon.loadUserCourses(auth.currentUser.value.id ?? "0");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(50, 239, 229, 248),
        title: const Text(
          "Flourse",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mis cursos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  child: PopupMenuButton<int>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: lilac,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Text('Crear un curso', style: TextStyle(color: lilac, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Text('Unirse a un curso', style: TextStyle(color: blue, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        // Mostrar el popup de crear curso
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.2),
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: const CreateCourseDialog(),
                          ),
                        );
                      } else if (value == 2) {
                        // Mostrar el popup de unirse a curso
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.2),
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: const JoinCourseDialog(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(125, 224, 224, 224),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Colors.black87, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Agregar',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 0.15, color: Colors.grey),
            const SizedBox(height: 12),
            RoleToggleButtons(
              isProfessor: _isProfessor,
              onChanged: (val) => setState(() => _isProfessor = val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final allCourses = courseCon.userCourses;
                final filteredCourses = allCourses.where((c) => _isProfessor ? c.userRole == 'Profesor' : c.userRole != 'Profesor').toList();
                if (filteredCourses.isEmpty) {
                  return const Center(
                    child: Text('No hay cursos disponibles.'),
                  );
                }
                return GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return CourseCard(courseInfo: course);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}