// lib/features/categories/ui/pages/groupDetailPage.dart
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
import 'package:flourse/features/reports/ui/controller/report_controller.dart'; // <-- Importa el ReportController
import 'package:flourse/features/reports/ui/pages/averages.dart';
import 'package:loggy/loggy.dart'; 

class GroupDetailPage extends StatefulWidget {
  final Group group;
  final Category category;
  final bool canEdit;

  const GroupDetailPage({
    super.key,
    required this.group,
    required this.category,
    required this.canEdit,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final CoursesController coursesController = Get.find();
  final GroupsController groupsController = Get.find();
  final ReportController reportController = Get.find();

  Future<void> _reload() async {
    await groupsController.getGroupById(widget.category.id ?? '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var group = groupsController.groups.firstWhere(
      (g) => g.id == widget.group.id,
      orElse: () => widget.group,
    );
    final category = widget.category;
    final canEdit = widget.canEdit;

    // Obtén el promedio del grupo
    final groupAverage = reportController.groupAverageScore(group.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Grupo'),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Miembros del Grupo:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // --- NUEVO: Promedio del grupo ---
                Card(
                  color: Colors.blue[50],
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildAverageColumn('Puntualidad', groupAverage[0]),
                            _buildAverageColumn('Contribuciones', groupAverage[1]),
                            _buildAverageColumn('Compromiso', groupAverage[2]),
                            _buildAverageColumn('Actitud', groupAverage[3]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (group.memberIDs.isEmpty)
                  const Text('El grupo no tiene miembros.')
                else
                  ...group.memberIDs.map((memberId) {
                    final userAvg = reportController.userAverageScore(
                      memberId,
                      groupId: group.id,
                    );
                    logInfo("User $memberId average: $userAvg");
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: FutureBuilder<String>(
                          future: coursesController.getUserNameById(memberId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Cargando...");
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Text("Desconocido");
                            }
                            return Text(snapshot.data!);
                          },
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              ...[
                                _buildMiniAvg("P", userAvg[0]),
                                _buildMiniAvg("C", userAvg[1]),
                                _buildMiniAvg("Co", userAvg[2]),
                                _buildMiniAvg("A", userAvg[3]),
                              ],
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.bar_chart, size: 16),
                                label: const Text("Ver "),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ShowEvaluationPage(scores: userAvg),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        trailing: canEdit
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () async {
                                  await groupsController.removeMemberFromGroup(
                                    group.id,
                                    memberId,
                                    category.id ?? '',
                                  );
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAverageColumn(String label, double value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildMiniAvg(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        label: Text("$label:$value", style: const TextStyle(fontSize: 11)),
        backgroundColor: Colors.blue[50],
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      ),
    );
  }
}