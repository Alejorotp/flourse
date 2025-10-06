import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/categories/ui/pages/current_category.dart';
import 'package:flourse/features/categories/ui/widgets/create_category_card.dart';
import 'package:flourse/features/categories/ui/widgets/category_list_card.dart';
import 'package:flourse/features/categories/ui/widgets/create_category_dialog.dart';
import 'package:flourse/features/evaluations/ui/widgets/create_evaluation_dialog.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flourse/features/courses/domain/models/course_info.dart';
import 'package:flourse/features/courses/ui/widgets/member_card.dart';
import 'package:flourse/features/courses/ui/widgets/professor_box.dart';
import 'package:flourse/features/courses/ui/widgets/course_code_box.dart';
import 'package:get/get.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/widgets/nav_item.dart';
import 'package:flourse/features/evaluations/ui/widgets/evaluation_list_card.dart';
import 'package:flourse/features/evaluations/ui/widgets/create_evaluation_card.dart';
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
  int _selectedNavIndex = 0;
  CategoriesController categoriesController = Get.find();

  static const lilac = Color.fromRGBO(124, 77, 255, 1);
  static const darkBlue = Color.fromARGB(255, 0, 124, 182);

  @override
  void initState() {
    super.initState();
    categoriesController = Get.find<CategoriesController>();
    evaluationController = Get.find<EvaluationController>();
  }

  @override
  Widget build(BuildContext context) {
    final courseInfo = widget.courseInfo;
    AuthenticationController auth = Get.find();

    final userId = auth.currentUser.value.id ?? '';
    final isProfessor = courseInfo.course.professorID == userId;

    categoriesController.fetchCategories();
    evaluationController.fetchAllEvaluations();
    final courseCategories = categoriesController.categories
        .where((cat) => cat.courseId == courseInfo.course.courseCode)
        .toList();
    final courseCategoryIDs = courseCategories.map((cat) => cat.id!).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(50, 239, 229, 248),
        title: Text(courseInfo.course.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: [
                // 0: Curso
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Box Profesor
                      ProfessorBox(professorName: courseInfo.professorName),



                      // Box código de curso (solo profe)
                      if (isProfessor) ...[
                        CourseCodeBox(courseCode: courseInfo.course.courseCode),
                      ],
                      const Divider(thickness: 0.25, color: Colors.grey),
                      const SizedBox(height: 4),
                      // Header Estudiantes con chip
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(40, 43, 213, 243),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.group,
                                    color: darkBlue, size: 26),
                                const SizedBox(width: 6),
                                Text(
                                  "Total de estudiantes: ${courseInfo.memberNames.length - 1}",
                                  style: const TextStyle(
                                    color: darkBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lista de estudiantes
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
                      //if (isProfessor)
                        CreateEvaluationCard(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.2),
                              builder: (context) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                child: CreateEvaluationDialog(courseId: courseInfo.course.courseCode),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final courseCategoryIDs = categoriesController.categories
                            .where((cat) =>
                                cat.courseId == courseInfo.course.courseCode)
                            .map((cat) => cat.id)
                            .whereType<String>()
                            .toList();

                        var evals = evaluationController.evaluations
                            .where((eval) =>
                                courseCategoryIDs.contains(eval.categoryID))
                            .toList();

                        if (evals.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                'No hay coevaluaciones para este curso.',
                                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: evals
                              .map((eval) => EvaluationListCard(
                                    evaluation: eval,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CurrentEvaluationPage(
                                              evaluation: eval),
                                        ),
                                      );
                                    },
                                  ))
                              .toList(),
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
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.2),
                              builder: (context) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                child: CreateCategoryDialog(course: courseInfo.course, canEdit: true),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 12),
                      if (courseCategoryIDs.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              'No hay categorías para este curso.',
                              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else ...courseCategoryIDs.map((catId) {
                        final cat = categoriesController.getCategoryById(catId);
                        if (cat == null) return const SizedBox.shrink();
                        return CategoryListCard(
                          category: cat,
                          activitiesCount: 0,
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
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom nav
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
                    iconColor: isProfessor ? lilac : darkBlue,
                    onTap: () {
                      setState(() => _selectedNavIndex = 0);
                    },
                  ),
                  NavItem(
                    icon: Icons.assignment_outlined,
                    label: "Coevaluaciones",
                    isActive: _selectedNavIndex == 1,
                    iconColor: isProfessor ? lilac : darkBlue,
                    onTap: () {
                      setState(() => _selectedNavIndex = 1);
                    },
                  ),
                  NavItem(
                    icon: Icons.group_outlined,
                    label: "Grupos",
                    isActive: _selectedNavIndex == 2,
                    iconColor: isProfessor ? lilac : darkBlue,
                    onTap: () {
                      setState(() => _selectedNavIndex = 2);
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