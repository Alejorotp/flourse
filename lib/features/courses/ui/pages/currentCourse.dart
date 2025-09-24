import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/categories/ui/pages/createCategory.dart';
import 'package:flourse/features/categories/ui/pages/currentCategory.dart';
import 'package:flourse/features/categories/ui/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';
import 'package:flourse/features/courses/ui/widgets/member_card.dart';
import 'package:flourse/features/courses/ui/widgets/professor_box.dart';
import 'package:flourse/features/courses/ui/widgets/course_code_box.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/widgets/Navitem.dart';
import 'package:loggy/loggy.dart';

class CurrentCoursePage extends StatefulWidget {
  static const String courseID = '/course-detail';
  final UserCourseInfo courseInfo;

  const CurrentCoursePage({super.key, required this.courseInfo});

  @override
  State<CurrentCoursePage> createState() => _CurrentCoursePageState();
}

class _CurrentCoursePageState extends State<CurrentCoursePage> {
  int _selectedNavIndex = 0; // <- índice seleccionado (visual)
  late CategoriesController categoriesController;

  @override
  void initState() {
    super.initState();
    categoriesController = Get.find<CategoriesController>();
  }

  @override
  Widget build(BuildContext context) {
    final courseInfo = widget.courseInfo;
    AuthenticationController auth = Get.find();
    final userId = auth.currentUser.value.id ?? '';
    final isProfessor = courseInfo.course.professorID == userId;
    categoriesController.fetchCategories();
    logInfo("Categories loaded: ${categoriesController.categories.length}");
    categoriesController.categories.forEach((cat) {
      logInfo("Category: ${cat.name}, CourseID: ${cat.courseId}");
    });
    final courseCategories = categoriesController.categories.where((cat) => cat.courseId == courseInfo.course.courseCode).toList();
    logInfo("Categories for course ${courseInfo.course.courseCode}: ${courseCategories.length}");
    // Get the category IDs for this course
    final courseCategoryIDs = courseCategories.map((cat) => cat.id!).toList();
    logInfo("Categories for course ${courseInfo.course.courseCode}: $courseCategories");
    logInfo("Categories inside courseInfo: $courseCategoryIDs");

    return Scaffold(
      appBar: AppBar(title: Text(courseInfo.course.title), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: [
                // 0: Info del curso
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfessorBox(professorName: courseInfo.professorName),
                      if (isProfessor) ...[
                        CourseCodeBox(courseCode: courseInfo.course.courseCode),
                      ],
                      Text(
                        "Total students: ${courseInfo.memberNames.length-1}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...courseInfo.memberNames
                      .where((name) => name != courseInfo.professorName)
                      .map((name) => MemberCard(name: name)),
                    ],
                  ),
                ),
                // 1: Evaluaciones (placeholder)
                const Center(child: Text('Evaluaciones (próximamente)')),
                // 2: Categorías (Grupos)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isProfessor)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CreateCategoryPage(
                                    course: courseInfo.course,
                                    canEdit: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text('+ crear categoría'),
                          ),
                        ),
                      ...courseCategoryIDs.map((catId) {
                        final cat = categoriesController.getCategoryById(catId);
                        logError("Category fetched for ID $catId: $cat");
                        if (cat == null) return const SizedBox.shrink();
                        return CategoryCard(
                          category: cat,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CurrentCategoryPage(
                                  category: cat,
                                  canEdit: isProfessor,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom navigation bar (clickeable y resalta el seleccionado)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(38, 0, 0, 0),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavItem(
                      icon: Icons.book_outlined,
                      label: "Curso",
                      isActive: _selectedNavIndex == 0,
                      onTap: () {
                        setState(() {
                          _selectedNavIndex = 0;
                        });
                      },
                    ),
                    NavItem(
                      icon: Icons.assignment_outlined,
                      label: "Evaluaciones",
                      isActive: _selectedNavIndex == 1,
                      onTap: () {
                        setState(() {
                          _selectedNavIndex = 1;
                        });
                      },
                    ),
                    NavItem(
                      icon: Icons.group_outlined,
                      label: "Grupos",
                      isActive: _selectedNavIndex == 2,
                      onTap: () {
                        setState(() {
                          _selectedNavIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
            ),
          ),
        ],
      ),
    );
  }
}
