import 'package:flutter/material.dart';
import 'package:flourse/features/evaluations/ui/controller/evaluation_controller.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:get/get.dart';

class CreateEvaluationPage extends StatefulWidget {
  final String courseId;
  const CreateEvaluationPage({super.key, required this.courseId});

  @override
  State<CreateEvaluationPage> createState() => _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends State<CreateEvaluationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedVisibility;
  String? _selectedCategoryId;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.find<CategoriesController>();
    final evaluationController = Get.find<EvaluationController>();
    final courseCategories = categoriesController.categories.where((cat) => cat.courseId == widget.courseId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evaluación'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la evaluación',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: courseCategories.map((cat) => DropdownMenuItem(
                  value: cat.id,
                  child: Text(cat.name),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategoryId = val;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedVisibility,
                decoration: const InputDecoration(
                  labelText: 'Visibilidad',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Publica', child: Text('Publica')),
                  DropdownMenuItem(value: 'Privada', child: Text('Privada')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedVisibility = val;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Selecciona visibilidad' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      evaluationController.createEvaluation(
                        name: _nameController.text,
                        categoryId: _selectedCategoryId!,
                        visibility: _selectedVisibility!,
                        creationDate: DateTime.now().toIso8601String(),
                      );
                      Navigator.of(context).pop('created');
                    }
                  },
                  child: const Text('Crear Evaluación'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
