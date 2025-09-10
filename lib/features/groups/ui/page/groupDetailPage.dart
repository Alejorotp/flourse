// lib/features/categories/ui/pages/groupDetailPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/domain/models/group.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
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
  final CategoriesController categoriesController = Get.find();
  final AuthenticationController auth = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Miembros del Grupo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (widget.group.memberIds.isEmpty)
              const Text('El grupo no tiene miembros.')
            else
              ...widget.group.memberIds.map((memberId) {
                return ListTile(
                  title: Text(memberId), // Replace with member's name
                  trailing: widget.canEdit
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            categoriesController.removeMemberFromGroup(
                              widget.group.id,
                              memberId,
                            );
                            // Refresh UI
                            setState(() {});
                          },
                        )
                      : null,
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}