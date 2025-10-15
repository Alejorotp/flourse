import 'package:flutter/material.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:get/get.dart';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/reports/ui/controller/report_controller.dart';
import 'evaluate.dart';
import 'package:flourse/features/reports/ui/pages/averages.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';

class CurrentEvaluationPage extends StatelessWidget {
  static const String id = '/evaluation-detail';
  final Evaluation evaluation;
  final bool isProfessor;

  const CurrentEvaluationPage({
    super.key,
    required this.evaluation,
    required this.isProfessor,
  });

  @override
  Widget build(BuildContext context) {
    final GroupsController groupsController = Get.find();
    final ReportController reportController = Get.find();
    final CategoriesController categoriesController = Get.find();
    final String currentUserId =
        Get.find<AuthenticationController>().currentUser.value.id ?? '';

    // Calcula el promedio de la actividad una sola vez aquí
    final avg = reportController.activityAverageScore(evaluation.evaluationID);

    // Busca el nombre de la categoría
    final category = categoriesController.categories
        .firstWhereOrNull((c) => c.id == evaluation.categoryID);
    final categoryName = category?.name ?? "Categoría desconocida";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de Evaluación"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evaluation.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Evaluación ID: ${evaluation.evaluationID}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.deepPurpleAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category, size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Text(
                    "Categoría: $categoryName",
                    style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    "Creada: ${evaluation.creationDate}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.visibility, size: 16, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    "Visibilidad: ${evaluation.visibility}",
                    style: const TextStyle(fontSize: 14, color: Colors.teal),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              if (isProfessor)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("Ver promedio de la actividad"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ShowEvaluationPage(scores: avg),
                        ),
                      );
                    },
                  ),
                ),
              if (isProfessor) const SizedBox(height: 32),

              if (!isProfessor) ...[
                const Text(
                  "Compañeros en tu grupo:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Group>>(
                  future:
                      groupsController.getAllGroups(categoryId: evaluation.categoryID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text("No hay grupos disponibles."),
                      );
                    }

                    final groups = snapshot.data!
                        .where((g) => g.categoryID == evaluation.categoryID)
                        .toList();

                    final userGroup = groups
                            .where((g) => g.memberIDs.contains(currentUserId))
                            .isNotEmpty
                        ? groups.firstWhere(
                            (g) => g.memberIDs.contains(currentUserId),
                          )
                        : null;

                    if (userGroup == null) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text("No estás en ningún grupo para esta categoría."),
                      );
                    }

                    final teammates = userGroup.memberIDs
                        .where((id) => id != currentUserId)
                        .toList();

                    if (teammates.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text("No tienes compañeros en este grupo."),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: teammates.map((memberId) {
                          return FutureBuilder<String>(
                            future: Get.find<CoursesController>().getUserNameById(
                              memberId,
                            ),
                            builder: (context, nameSnapshot) {
                              final name = nameSnapshot.data ?? memberId;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Seleccionaste a $name')),
                                  );
                                  Get.to(
                                    () => EvaluatePage(
                                      teammateId: memberId,
                                      teammateName: name,
                                      evaluation: evaluation,
                                      groupID: userGroup.id,
                                    ),
                                  );
                                },
                                child: Text(name),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ] else ...[
                const Text(
                  "Grupos con coevaluaciones realizadas:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                FutureBuilder(
                  future: reportController
                      .fetchReportsByEvaluationId(evaluation.evaluationID)
                      .then((_) async {
                    final uniqueGroupIds = evaluation.categoryID;
                    final evaluatedGroups = await groupsController.getGroupById(uniqueGroupIds);
                    return evaluatedGroups;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text("Aún no hay grupos que hayan realizado coevaluaciones."),
                      );
                    }

                    final evaluatedGroups = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: evaluatedGroups.map<Widget>((group) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                "Grupo ${group.groupNumber}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Integrantes: ${group.memberIDs.length}"),
                              leading: const Icon(Icons.group, color: Colors.blue),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
