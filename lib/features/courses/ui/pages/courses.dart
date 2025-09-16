import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:flourse/features/home/ui/widgets/course_card.dart';
import 'package:get/get.dart';

class CoursesPage extends StatefulWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool showFloatingButtons = false;

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();
    CoursesController courseCon = Get.find();

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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (showFloatingButtons) {
            setState(() {
              showFloatingButtons = false;
            });
          }
        },
        child: Padding(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  showFloatingButtons
                      ? Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.create, color: Colors.blue, size: 32),
                              tooltip: 'Create Course',
                              onPressed: () {
                                setState(() => showFloatingButtons = false);
                                Navigator.of(context).pushNamed('/create-course');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.group_add, color: Colors.green, size: 32),
                              tooltip: 'Join Course',
                              onPressed: () {
                                setState(() => showFloatingButtons = false);
                                Navigator.of(context).pushNamed('/join-course');
                              },
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              showFloatingButtons = true;
                            });
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

              Expanded(
                child: Obx(
                  () => FutureBuilder(
                  future: courseCon.getCourseInfo(auth.currentUser.value.id ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      ); // Muestra un spinner mientras carga
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      ); // Muestra un mensaje si hay un error
                    } else if (snapshot.hasData) {
                      final filteredCourses = snapshot.data!;
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
                    } else {
                      return const Center(
                        child: Text('No hay cursos disponibles.'),
                      ); // Si no hay datos
                    }
                  },
                ),
                )
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
