import 'package:flutter/material.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/courses/domain/models/course.dart';
import 'package:get/get.dart';

class CreateCategoryPage extends StatefulWidget {
  static const String id = '/create-category';
  final Course course;
  final bool canEdit;

  const CreateCategoryPage({
    super.key,
    required this.course,
    required this.canEdit,
  });

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _maxMembersController = TextEditingController();

  String? _selectedGrouping;
  final List<String> _groupingOptions = [
    "Auto asignado",
    "Libre elección",
  ];

  @override
  Widget build(BuildContext context) {
    CategoriesController categoriesController = Get.find();

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
            DropdownButtonFormField<String>(
              initialValue: _selectedGrouping,
              items: _groupingOptions
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGrouping = value;
                });
              },
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
            if (widget.canEdit)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final grouping = _selectedGrouping ?? "";
                    final maxMembers =
                        int.tryParse(_maxMembersController.text.trim()) ?? 0;

                    if (name.isNotEmpty &&
                        grouping.isNotEmpty &&
                        maxMembers > 0) {
                      categoriesController.createCategory(
                        name: name,
                        groupingMethod: grouping,
                        maxMembers: maxMembers,
                        course: widget.course,
                      );
                      Navigator.of(context).pop();
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