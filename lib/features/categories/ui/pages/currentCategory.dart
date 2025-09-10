import 'package:flutter/material.dart';
import 'package:flourse/features/categories/domain/models/category.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
//import 'package:flourse/features/categories/ui/pages/groupsPage.dart'; // Importa la página de grupos
import 'package:flourse/features/groups/ui/page/groupsPage.dart';
import 'package:get/get.dart';

class CurrentCategoryPage extends StatefulWidget {
  static const String id = '/category-detail';
  final Category category;
  final bool canEdit;

  const CurrentCategoryPage({
    super.key,
    required this.category,
    this.canEdit = false,
  });

  @override
  State<CurrentCategoryPage> createState() => _CurrentCategoryPageState();
}

class _CurrentCategoryPageState extends State<CurrentCategoryPage> {
  final categoriesController = CategoriesController();
  late TextEditingController _nameController;
  late TextEditingController _groupingController;
  late TextEditingController _maxMembersController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _groupingController = TextEditingController(
      text: widget.category.groupingMethod,
    );
    _maxMembersController = TextEditingController(
      text: widget.category.maxMembers.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupingController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Show editable fields for professor, plain text for students
            if (widget.canEdit) ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  "Editar categoría",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega a GroupsPage
                    Get.to(() => GroupsPage(
                          category: widget.category,
                          canEdit: widget.canEdit,
                        ));
                  },
                  child: const Text('Ver Grupos'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    categoriesController.updateCategory(
                      id: widget.category.id,
                      newName: _nameController.text,
                      newGroupingMethod: _groupingController.text,
                      newMaxMembers: int.tryParse(_maxMembersController.text),
                    );
                    Navigator.of(context).pop('updated');
                  },
                  child: const Text("Actualizar"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    categoriesController.deleteCategory(widget.category.id);
                    Navigator.of(context).pop('deleted');
                  },
                  child: const Text("Eliminar"),
                ),
              ),
            ] else ...[
              Text(
                widget.category.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Método de agrupación: ${widget.category.groupingMethod}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Máximo de miembros: ${widget.category.maxMembers}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega a GroupsPage
                    Get.to(() => GroupsPage(
                          category: widget.category,
                          canEdit: widget.canEdit,
                        ));
                  },
                  child: const Text('Ver Grupos'),
                ),
              ),
              const SizedBox.shrink(),
            ],
          ],
        ),
      ),
    );
  }
}
