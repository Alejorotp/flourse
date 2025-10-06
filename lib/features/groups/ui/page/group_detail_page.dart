// lib/features/categories/ui/pages/groupDetailPage.dart
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/groups/ui/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/groups/domain/models/groups.dart';
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
  final GroupsController groupsController = Get.find();
  final AuthenticationController auth = Get.find();
  final CoursesController coursesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Grupo'),
      ),
      body: FutureBuilder<List<Group?>?>( // <-- Se utiliza FutureBuilder
        future: groupsController.getGroupById(widget.group.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('El grupo no existe.'));
          }

          final updatedGroup = snapshot.data!.first;

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
                if (updatedGroup!.memberIDs.isEmpty)
                  const Text('El grupo no tiene miembros.')
                else
                  ...updatedGroup.memberIDs.map((memberId) {
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
                      trailing: widget.canEdit
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () async { // <-- Se añade async
                                await groupsController.removeMemberFromGroup( 
                                    widget.group.id, memberId,
                                    widget.category.id ?? '',
                                );
                                setState(() {});
                              },
                            )
                          : null,
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}