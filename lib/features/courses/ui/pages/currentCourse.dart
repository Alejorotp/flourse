import 'package:flutter/material.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/home/ui/widgets/category_card.dart';
import 'package:flourse/features/categories/ui/pages/createCategory.dart';
import 'package:flourse/features/categories/ui/pages/currentCategory.dart';
import 'package:get/get.dart';
import 'package:flourse/domain/use_case/auth_controller.dart';

class CurrentCoursePage extends StatefulWidget {
  static const String id = '/course-detail';
  final UserCourseInfo courseInfo;

  const CurrentCoursePage({super.key, required this.courseInfo});

  @override
  State<CurrentCoursePage> createState() => _CurrentCoursePageState();
}

class _CurrentCoursePageState extends State<CurrentCoursePage> {
  final CategoriesController categoriesController = CategoriesController();

  @override
  Widget build(BuildContext context) {
    final courseInfo = widget.courseInfo;

    return Scaffold(
      appBar: AppBar(title: Text(courseInfo.course.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Código del curso: ${courseInfo.course.courseCode}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Profesor: ${courseInfo.professorName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Total de miembros: ${courseInfo.memberNames.length}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Lista de estudiantes:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...courseInfo.memberNames.map((name) => Text('- $name')),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categorías del curso",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (context) {
                    final auth = Get.find<AuthController>();
                    final userId = auth.currentUser.value?.id ?? '';
                    final isProfessor = courseInfo.course.professorID == userId;
                    if (!isProfessor) return const SizedBox.shrink();
                    return InkWell(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateCategoryPage(
                              course: courseInfo.course,
                              canEdit: isProfessor,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (courseInfo.course.categoryIDs.isEmpty)
              const Text('No hay categorías asignadas.')
            else
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: courseInfo.course.categoryIDs.length,
                itemBuilder: (context, index) {
                  final id = courseInfo.course.categoryIDs[index];
                  final category = categoriesController.getCategoryById(id);
                  if (category == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CategoryCard(
                      category: category,
                      onTap: () async {
                        final auth = Get.find<AuthController>();
                        final userId = auth.currentUser.value?.id ?? '';
                        final isProfessor =
                            courseInfo.course.professorID == userId;
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CurrentCategoryPage(
                              category: category,
                              canEdit: isProfessor,
                            ),
                          ),
                        );
                        if (result == 'deleted') {
                          widget.courseInfo.course.categoryIDs.remove(
                            category.id,
                          );
                        }
                        // If updated or deleted, refresh the UI to show latest category data
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
