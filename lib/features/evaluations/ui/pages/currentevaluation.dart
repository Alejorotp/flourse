import 'package:flutter/material.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:get/get.dart';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/reports/ui/controller/report_controller.dart';
import 'package:loggy/loggy.dart';
import 'evaluate.dart';

class CurrentEvaluationPage extends StatelessWidget {
  static const String id = '/evaluation-detail';
  final Evaluation evaluation;
  final bool isProfessor; // ✅ Variable recibida desde el constructor

  const CurrentEvaluationPage({
    super.key,
    required this.evaluation,
    required this.isProfessor,
  });

  @override
  Widget build(BuildContext context) {
    final GroupsController groupsController = Get.find();
    final ReportController reportController = Get.find();
    final String currentUserId =
        Get.find<AuthenticationController>().currentUser.value.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de Evaluación"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre: ${evaluation.name}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "ID de Evaluación: ${evaluation.evaluationID}",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              "ID de Categoría: ${evaluation.categoryID}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Fecha de creación: ${evaluation.creationDate}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Visibilidad: ${evaluation.visibility}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // ✅ Lógica condicional según si es profesor o estudiante
            if (!isProfessor) ...[
              const Text(
                "Compañeros en tu grupo:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Group>>(
                future:
                    groupsController.getAllGroups(categoryId: evaluation.categoryID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No hay grupos disponibles.");
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
                    return const Text(
                      "No estás en ningún grupo para esta categoría.",
                    );
                  }

                  final teammates = userGroup.memberIDs
                      .where((id) => id != currentUserId)
                      .toList();

                  if (teammates.isEmpty) {
                    return const Text("No tienes compañeros en este grupo.");
                  }

                  return Wrap(
                    spacing: 8,
                    children: teammates.map((memberId) {
                      return FutureBuilder<String>(
                        future: Get.find<CoursesController>().getUserNameById(
                          memberId,
                        ),
                        builder: (context, nameSnapshot) {
                          final name = nameSnapshot.data ?? memberId;
                          return ElevatedButton(
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
                  );
                },
              ),
            ] else ...[
              const Text(
                "Grupos con coevaluaciones realizadas:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ Lógica para el profesor
              FutureBuilder(
                future: reportController
                    .fetchReportsByEvaluationId(evaluation.evaluationID)
                    .then((_) async {
                  // Filtrar los IDs de grupos únicos
                  final reports = reportController.reports;
                  final uniqueGroupIds = evaluation.categoryID;
                  logInfo(uniqueGroupIds);
                  // Obtener los grupos por ID
                  final evaluatedGroups =   await groupsController.getGroupById(uniqueGroupIds);
                  for (var group in evaluatedGroups) {
                    logInfo("Group fetched: ${group.groupNumber}");
                  }
                  return evaluatedGroups;
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      "Aún no hay grupos que hayan realizado coevaluaciones.",
                    );
                  }

                  final evaluatedGroups = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: evaluatedGroups.map((group) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            "Grupo ${group.groupNumber}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Integrantes: ${group.memberIDs.length}"),
                          leading: const Icon(Icons.group, color: Colors.blue),
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
    );
  }
}
