// lib/features/categories/ui/pages/groupsPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/categories/ui/pages/groupDetailPage.dart';

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
  final CategoriesController categoriesController = Get.find();
  final AuthenticationController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos de ${widget.category.name}'),
      ),
      body: FutureBuilder(
        future: categoriesController.getGroupsByCategory(widget.category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final groups = snapshot.data!;
            final currentUserId = auth.currentUser.value.id;
            final userInGroup = groups.any(
                (group) => group.memberIds.contains(currentUserId));

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
                  if (groups.isEmpty)
                    const Center(
                      child: Text(
                        'No hay grupos creados para esta categoría.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final isFull = group.memberIds.length >=
                            widget.category.maxMembers;
                        final isUserInThisGroup =
                            group.memberIds.contains(currentUserId);

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
                                '${group.memberIds.length} / ${widget.category.maxMembers} miembros'),
                            trailing: !widget.canEdit && !userInGroup && !isFull
                                ? ElevatedButton(
                                    onPressed: () {
                                      categoriesController.joinGroup(
                                        group.id,
                                        currentUserId!,
                                      );
                                      // Refresh UI
                                      setState(() {});
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
          } else {
            return const Center(child: Text('No se encontraron grupos.'));
          }
        },
      ),
    );
  }
}