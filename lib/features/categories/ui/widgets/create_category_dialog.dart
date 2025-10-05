import 'package:flutter/material.dart';
import 'package:flourse/features/categories/ui/controller/categories_controller.dart';
import 'package:flourse/features/courses/domain/models/course.dart';
import 'package:get/get.dart';

class CreateCategoryDialog extends StatefulWidget {
  final Course course;
  final bool canEdit;
  const CreateCategoryDialog({super.key, required this.course, required this.canEdit});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _maxMembersController = TextEditingController();
  String? _selectedGrouping;
  final List<String> _groupingOptions = ["Aleatorio", "Libre elección"];

  static const lilac = Color.fromRGBO(124, 77, 255, 1);

  @override
  Widget build(BuildContext context) {
    CategoriesController categoriesController = Get.find();

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
                    child: const Icon(Icons.category_outlined, color: lilac, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Crear categoría",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lilac,
                        ),
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
                        "Agrega una nueva categoría al curso. Las categorías te permiten agrupar las coevaluaciones de tu curso mediante grupos.",
                        style: TextStyle(fontSize: 13.5, color: lilac),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Nombre de la categoría",
                style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Ej: Prácticas, Exámenes, Proyectos",
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
                "Método de agrupación",
                style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
              ),
              const SizedBox(height: 6),
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
              ),
              const SizedBox(height: 14),
              const Text(
                "Número de integrantes por grupo",
                style: TextStyle(fontWeight: FontWeight.w600, color: lilac),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _maxMembersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ej: 3, 4, 5",
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
              const SizedBox(height: 22),
              if (widget.canEdit)
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
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final grouping = _selectedGrouping ?? "";
                      final maxMembers = int.tryParse(_maxMembersController.text.trim()) ?? 0;
                      if (name.isNotEmpty && grouping.isNotEmpty && maxMembers > 0) {
                        categoriesController.createCategory(
                          name: name,
                          groupingMethod: grouping,
                          maxMembers: maxMembers,
                          course: widget.course,
                        );
                        Get.snackbar(
                          "Éxito",
                          "Categoría creada exitosamente.",
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        Navigator.of(context).pop();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Todos los campos son obligatorios y el número de integrantes por grupo debe ser mayor a 0",
                          icon: const Icon(Icons.error, color: Colors.red),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Crear categoría", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              else
                const Text('No tienes permisos para crear categorías'),
            ],
          ),
        ),
      ),
    );
  }
}

