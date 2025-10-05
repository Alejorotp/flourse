import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

class CreateCourseDialog extends StatelessWidget {
  const CreateCourseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    CoursesController courseCon = Get.find();
    AuthenticationController auth = Get.find();

    return Dialog(
      backgroundColor: const Color.fromARGB(245, 247, 237, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                  child: const Icon(Icons.add_circle_outline, color: Color.fromRGBO(124, 77, 255, 1), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Crear nuevo curso",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(124, 77, 255, 1)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color.fromRGBO(124, 77, 255, 1)),
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
                  Icon(Icons.info_outline, color: Color.fromRGBO(124, 77, 255, 1), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Puedes crear hasta 3 cursos.\nAl crear un curso se generará un código que deberás compartir con tus estudiantes.",
                      style: TextStyle(fontSize: 13.5, color: Color.fromRGBO(124, 77, 255, 1)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Nombre del curso",
              style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(124, 77, 255, 1)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Ej: Matemáticas 101",
                filled: true,
                fillColor: const Color.fromARGB(15, 124, 77, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color.fromRGBO(124, 77, 255, 1), width: 2),
                ),
              ),
              cursorColor: Color.fromRGBO(124, 77, 255, 1),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(124, 77, 255, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 1.5,
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Crear curso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final userId = auth.currentUser.value.id?.toString() ?? '';
                    final created = await courseCon.createCourse(
                      title: name,
                      professorID: userId,
                    );
                    if (created) {
                      Get.snackbar(
                        "Éxito",
                        "Curso creado éxitosamente. Recuerda compartir el código con tus estudiantes.",
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        "Error",
                        "No puedes ser profesor de más de 3 cursos",
                        icon: const Icon(Icons.error, color: Colors.red),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  } else {
                    Get.snackbar(
                      "Error",
                      "El nombre no puede estar vacío",
                      icon: const Icon(Icons.error, color: Colors.red),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
