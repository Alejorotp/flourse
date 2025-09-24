import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/categories/ui/pages/createCategory.dart';
import 'package:flourse/features/categories/ui/pages/currentCategory.dart';
import 'package:flourse/features/categories/ui/widgets/create_category_card.dart';
import 'package:flourse/features/categories/ui/widgets/category_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';
import 'package:flourse/features/courses/ui/widgets/member_card.dart';
import 'package:flourse/features/courses/ui/widgets/professor_box.dart';
import 'package:flourse/features/courses/ui/widgets/course_code_box.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/widgets/Navitem.dart';
import 'package:loggy/loggy.dart';
import 'package:flourse/features/evaluations/ui/widgets/evaluation_list_card.dart';
import 'package:flourse/features/evaluations/ui/widgets/create_evaluation_card.dart';
import 'package:flourse/features/evaluations/ui/pages/createEvaluation.dart';
// import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/ui/controller/evaluation_controller.dart';
import 'package:flourse/features/evaluations/ui/pages/currentevaluation.dart';

class CurrentCoursePage extends StatefulWidget {
  static const String courseID = '/course-detail';
  final UserCourseInfo courseInfo;

  const CurrentCoursePage({super.key, required this.courseInfo});

  @override
  State<CurrentCoursePage> createState() => _CurrentCoursePageState();
}

class _CurrentCoursePageState extends State<CurrentCoursePage> {
  EvaluationController evaluationController = Get.find();
  int _selectedNavIndex = 0; // <- índice seleccionado (visual)
  CategoriesController categoriesController = Get.find();
  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  static const blue = Color.fromRGBO(31, 195, 224, 1); // celeste

  @override
  void initState() {
    super.initState();
    categoriesController = Get.find<CategoriesController>();
    evaluationController = Get.find<EvaluationController>();
    // Filtrar evaluaciones por las categorías de este curso
    Future.microtask(() {
      final courseCategoryIDs = categoriesController.categories
          .where((cat) => cat.courseId == widget.courseInfo.course.courseCode)
          .map((cat) => cat.id)
          .whereType<String>()
          .toList();
      // Obtener todas las evaluaciones de las categorías del curso
      for (final catId in courseCategoryIDs) {
        evaluationController.fetchEvaluationsByCategory(catId);
      }
    });
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
                        "Total de estudiantes: ${courseInfo.memberNames.length - 1}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...courseInfo.memberNames
                      .where((name) => name != courseInfo.professorName)
                      .map((name) => MemberCard(name: name)),
                    ],
                  ),
                ),
                // 1: Evaluaciones
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isProfessor)
                        CreateEvaluationCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CreateEvaluationPage(courseId: courseInfo.course.courseCode),
                              ),
                            );
                          },
                        ),
                      Obx(() {
                        final courseCategoryIDs = categoriesController.categories
                            .where((cat) => cat.courseId == courseInfo.course.courseCode)
                            .map((cat) => cat.id)
                            .whereType<String>()
                            .toList();
                        final evals = evaluationController.evaluations
                            .where((eval) => courseCategoryIDs.contains(eval.categoryID))
                            .toList();
                        if (evals.isEmpty) {
                          return const Center(child: Text('No hay evaluaciones para este curso.'));
                        }
                        return Column(
                          children: evals.map((eval) => EvaluationListCard(
                            evaluation: eval,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CurrentEvaluationPage(evaluation: eval),
                                ),
                              );
                            },
                          )).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                // 2: Categorías (Grupos)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isProfessor)
                        CreateCategoryCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CreateCategoryPage(
                                  course: courseInfo.course,
                                  canEdit: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ...courseCategoryIDs.map((catId) {
                        final cat = categoriesController.getCategoryById(catId);
                        if (cat == null) return const SizedBox.shrink();
                        return CategoryListCard(
                          category: cat,
                          activitiesCount: 0, // TODO: conectar con actividades reales
                          groupsCount: cat.groupIDs.length,
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
                    iconColor: isProfessor ? lilac : blue,
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
                    iconColor: isProfessor ? lilac : blue,
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
                    iconColor: isProfessor ? lilac : blue,
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
