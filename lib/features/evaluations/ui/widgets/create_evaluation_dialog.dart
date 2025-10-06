import 'package:flutter/material.dart';
import 'package:flourse/features/evaluations/ui/controller/evaluation_controller.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:get/get.dart';
//import 'dart:ui';

class CreateEvaluationDialog extends StatefulWidget {
  final String courseId;
  const CreateEvaluationDialog({super.key, required this.courseId});

  @override
  State<CreateEvaluationDialog> createState() => _CreateEvaluationDialogState();
}

class _CreateEvaluationDialogState extends State<CreateEvaluationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedVisibility;
  String? _selectedCategoryId;

  static const lilac = Color.fromRGBO(124, 77, 255, 1);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.find<CategoriesController>();
    final evaluationController = Get.find<EvaluationController>();
    final courseCategories = categoriesController.categories
        .where((cat) => cat.courseId == widget.courseId)
        .toList();

    final double dialogWidth = MediaQuery.of(context).size.width > 500
        ? 500
        : MediaQuery.of(context).size.width * 0.95;

    return Dialog(
      backgroundColor: const Color.fromARGB(245, 247, 237, 255),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(60, 124, 77, 255),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.assignment_outlined, color: lilac, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Crear coevaluación",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: lilac),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: lilac),
                      onPressed: () => Navigator.of(context).pop(),
                      splashRadius: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(30, 124, 77, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: lilac, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Crea una nueva coevaluación para tus estudiantes. Las coevaluaciones pueden ser públicas o privadas y se asignan a una categoría.",
                          style: TextStyle(fontSize: 13.5, color: lilac),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Nombre de la coevaluación",
                  style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Ej: Parcial 1, Quiz, Proyecto final",
                    filled: true,
                    fillColor: const Color.fromARGB(15, 124, 77, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: lilac, width: 2),
                    ),
                  ),
                  cursorColor: lilac,
                ),
                const SizedBox(height: 14),
                const Text(
                  "Categoría",
                  style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(15, 124, 77, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: lilac, width: 2),
                    ),
                  ),
                  items: courseCategories
                      .map((cat) => DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryId = val;
                    });
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  "Visibilidad",
                  style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedVisibility,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(15, 124, 77, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: lilac, width: 2),
                    ),
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
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lilac,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 1.5,
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Crear coevaluación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final categoryId = _selectedCategoryId ?? "";
                      final visibility = _selectedVisibility ?? "";
                      if (name.isEmpty || categoryId.isEmpty || visibility.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Todos los campos son obligatorios.",
                          icon: const Icon(Icons.error, color: Colors.red),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      evaluationController.createEvaluation(
                        name: name,
                        categoryId: categoryId,
                        visibility: visibility,
                        creationDate: DateTime.now().toIso8601String(),
                      );
                      Get.snackbar(
                        "Éxito",
                        "Evaluación creada exitosamente.",
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Navigator.of(context).pop('created');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
