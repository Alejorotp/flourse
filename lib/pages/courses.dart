import 'package:flutter/material.dart';
import 'package:flourse/data.dart'; 
import 'package:flourse/widgets/course_card.dart'; 

class CoursesPage extends StatelessWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar de la página ---
      appBar: AppBar(
        title: const Text('App title'),
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
                    // Lógica para añadir un nuevo curso
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
                itemCount: myCourses.length,
                itemBuilder: (context, index) {
                  final course = myCourses[index];
                  // Usamos el widget CourseCard y le pasamos el objeto 'course'
                  return CourseCard(course: course);
                },
              ),
            ),
          ],
        ),
      ),
      // --- Botón flotante ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para el botón flotante
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}