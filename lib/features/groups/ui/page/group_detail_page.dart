// lib/features/categories/ui/pages/groupDetailPage.dart
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
class GroupDetailPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final CoursesController coursesController = Get.find();
    final GroupsController groupsController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Miembros del Grupo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (group.memberIDs.isEmpty)
              const Text('El grupo no tiene miembros.')
            else
              ...group.memberIDs.map((memberId) {
                return ListTile(
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
                  trailing: canEdit
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () async {
                            await groupsController.removeMemberFromGroup(
                              group.id,
                              memberId,
                              category.id ?? '',
                            );
                            // Si quieres refrescar la UI, puedes usar setState en un StatefulWidget
                          },
                        )
                      : null,
                );
              }),
          ],
        ),
      ),
    );
  }
}