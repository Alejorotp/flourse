import 'package:flutter/material.dart';
import 'package:flourse/data/data.dart'; 
import 'package:flourse/presentation/widgets/course_card.dart'; 
import 'package:get/get.dart';
import 'package:flourse/domain/use_case/auth_controller.dart';
import 'package:flourse/domain/use_case/user_courses.dart';

class CoursesPage extends StatelessWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {

    //Filtra los cursos del user (Borrar después cuando se traiga los cursos filtrados desde la DB)
    final auth = Get.find<AuthController>();
    final userId = auth.currentUser.value?.id ?? '';
    final filteredCourses = getUserCoursesInfo(myCourses, userId);

    return Scaffold(
      // --- AppBar de la página ---
      appBar: AppBar(
        title: const Text('Flourse'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person_outline),
          ),
        ],
      ),
      // --- Cuerpo de la página ---
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- Encabezado "My Courses" ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/create-course');
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 12),

            // --- Botones de "Sort" y "Filter" ---
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para ordenar
                  },
                  icon: const Icon(Icons.sort),
                  label: const Text('Sort'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // Lógica para filtrar
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- GridView de los cursos ---
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}