// lib/features/categories/ui/pages/groupsPage.dart
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/groups/ui/page/group_detail_page.dart';
import 'package:loggy/loggy.dart';

class GroupsPage extends StatefulWidget {
  static const String id = '/groups-page';
  final Category category;
  final bool canEdit;
  final int groupNumber;

  const GroupsPage({
    super.key,
    required this.category,
    required this.canEdit,
    required this.groupNumber,
  });

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final GroupsController groupsController = Get.find();
  final AuthenticationController auth = Get.find();
  
  // Llama a getAllGroups para cargar los datos al inicio
  @override
  void initState() {
    super.initState();
    groupsController.getAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos de ${widget.category.name}'),
      ),
      body: Obx(
        () {
          var groups = groupsController.groups
              .where((group) => group.categoryID == widget.category.id)
              .toList();

          final currentUserId = auth.currentUser.value.id;
          var userInGroup = groups.any(
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
                      onPressed: () async { // <-- Se añade async
                        logInfo('Crear nuevo grupo en la categoría ${widget.category.name}');
                        await groupsController.createGroup( // <-- Se añade await
                          maxMembers: widget.category.maxMembers,
                          categoryId: widget.category.id ?? '', // <-- Se pasa el ID como String
                          groupNumber: widget.groupNumber, // esta chocora no sé de dónde toma la info, pero no debería servir porque debería ser random...
                        );
                        groupsController.getAllGroups(); // Refrescar la lista de grupos
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
                                    onPressed: () async { // <-- Se añade async
                                      await groupsController.joinGroup( // <-- Se añade await
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