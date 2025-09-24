import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';
import 'package:flourse/features/courses/ui/widgets/RoleToggleButtons.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _isProfessor = true;

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();
    CoursesController courseCon = Get.find();
    // Cargar cursos del usuario (solo una vez por build)
    courseCon.loadUserCourses(auth.currentUser.value.id ?? "0");

    return Scaffold(
      appBar: AppBar(
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurpleAccent, size: 32),
                      tooltip: 'Crear un curso',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/create-course');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.group_add, color: Colors.blue, size: 32),
                      tooltip: 'Unirse a un curso',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/join-course');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.grey),
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