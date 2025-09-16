// lib/features/categories/ui/pages/groupDetailPage.dart
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
//import 'package:flourse/features/groups/ui/controller/groups_controller.dart'; // Importación correcta
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

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
  // Ahora usamos el GroupsController
  final GroupsController groupsController = Get.find();
  final AuthenticationController auth = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Grupo'),
      ),
      // Usamos Obx para que la lista de miembros se actualice automáticamente
      body: Obx(
        () {
          final updatedGroup = groupsController.getGroupById(widget.group.id);
          if (updatedGroup == null) {
            return const Center(child: Text('El grupo no existe.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Miembros del Grupo:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (updatedGroup.memberIDs.isEmpty)
                  const Text('El grupo no tiene miembros.')
                else
                  ...updatedGroup.memberIDs.map((memberId) {
                    return ListTile(
                      title: Text(memberId.toString()), // Reemplazar con el nombre del miembro
                      trailing: widget.canEdit
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () {
                                groupsController.removeMemberFromGroup(
                                  updatedGroup.id,
                                  memberId,
                                );
                              },
                            )
                          : null,
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}