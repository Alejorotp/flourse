import 'package:flutter/material.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/courses/domain/models/course.dart';


class CreateCategoryPage extends StatelessWidget {
  static const String id = '/create-category';
  final Course course;
  final bool canEdit;

  const CreateCategoryPage({
    super.key,
    required this.course,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _groupingController = TextEditingController();
    final TextEditingController _maxMembersController = TextEditingController();
    CategoriesController categoriesController = CategoriesController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flourse"),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.settings),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Crear nueva categoría",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre de la categoría",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _groupingController,
              decoration: const InputDecoration(
                labelText: "Método de agrupación",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maxMembersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Máximo de miembros",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (canEdit)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final grouping = _groupingController.text.trim();
                    final maxMembers =
                        int.tryParse(_maxMembersController.text.trim()) ?? 0;
                    if (name.isNotEmpty &&
                        grouping.isNotEmpty &&
                        maxMembers > 0) {
                      categoriesController.createCategory(
                        name: name,
                        groupingMethod: grouping,
                        maxMembers: maxMembers,
                        course: course,
                      );
                      Navigator.of(context).pop(); // Return true after creating
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Todos los campos son obligatorios y el máximo de miembros debe ser mayor a 0',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text("Crear"),
                ),
              )
            else
              const Text('No tienes permisos para crear categorías'),
          ],
        ),
      ),
    );
  }
}
