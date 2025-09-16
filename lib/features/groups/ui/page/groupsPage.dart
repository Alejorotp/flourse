// lib/features/categories/ui/pages/groupsPage.dart
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
//import 'package:flourse/features/groups/ui/controller/groups_controller.dart'; // Importación correcta
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
//import 'package:flourse/features/groups/ui/pages/groupDetailPage.dart';
import 'package:flourse/features/groups/ui/page/groupDetailPage.dart';
//import 'package:loggy/loggy.dart';

class GroupsPage extends StatefulWidget {
  static const String id = '/groups-page';
  final Category category;
  final bool canEdit;

  const GroupsPage({
    super.key,
    required this.category,
    required this.canEdit,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // Ahora usamos el GroupsController
  final GroupsController groupsController = Get.find();
  final AuthenticationController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos de ${widget.category.name}'),
      ),
      // Usamos Obx para escuchar los cambios en la lista de grupos
      body: Obx(
        () {
          // Filtrado en tiempo real de los grupos de la categoría
          final groups = groupsController.groups
              .where((group) => widget.category.groupIDs.contains(group.id))
              .toList();

          final currentUserId = auth.currentUser.value.id;
          final userInGroup = groups.any(
              (group) => group.memberIDs.contains(currentUserId));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lista de Grupos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (widget.canEdit) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Crear nuevo grupo en la categoría ${widget.category.name}');
                        groupsController.createGroup(
                          id: groups.length + 1,
                          maxMembers: widget.category.maxMembers,
                          categoryId: widget.category,
                        );
                        setState(() {}); // Para refrescar la vista
                      },
                      child: const Text('Crear Grupo'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (groups.isEmpty)
                  const Center(
                    child: Text(
                      'No hay grupos creados para esta categoría.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final isFull = group.memberIDs.length >=
                            widget.category.maxMembers;
                        final isUserInThisGroup =
                            group.memberIDs.contains(currentUserId);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => GroupDetailPage(
                                    group: group,
                                    category: widget.category,
                                    canEdit: widget.canEdit,
                                  ));
                            },
                            title: Text('Grupo ${index + 1}'),
                            subtitle: Text(
                                '${group.memberIDs.length} / ${widget.category.maxMembers} miembros'),
                            trailing: !widget.canEdit && !userInGroup && !isFull
                                ? ElevatedButton(
                                    onPressed: () {
                                      groupsController.joinGroup(
                                        group.id,
                                        currentUserId!,
                                      );
                                    },
                                    child: const Text('Unirse'),
                                  )
                                : isUserInThisGroup
                                    ? const Icon(Icons.check, color: Colors.green)
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}