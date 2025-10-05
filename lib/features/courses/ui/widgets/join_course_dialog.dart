import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

class JoinCourseDialog extends StatelessWidget {
  static const blueBG = Color.fromARGB(24, 32, 210, 241);
  static const darkBlue = Color.fromARGB(255, 0, 124, 182);
  const JoinCourseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    CoursesController courseCon = Get.find();
    AuthenticationController auth = Get.find();

    return Dialog(
      backgroundColor: const Color.fromARGB(245, 247, 253, 255),
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
                    color: blueBG,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.person_add_alt_1_outlined, color: darkBlue, size: 28),
                ),
                const SizedBox(width: 12),
                // Texto flexible y adaptativo
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Unirse a un curso",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: darkBlue),
                  onPressed: () => Navigator.of(context).pop(),
                  splashRadius: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: blueBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: darkBlue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "El código del curso es proporcionado por el profesor.",
                      style: TextStyle(fontSize: 13.5, color: darkBlue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Código del curso",
              style: TextStyle(fontWeight: FontWeight.w600, color: darkBlue),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: "Ej: ABC123",
                filled: true,
                fillColor: const Color.fromARGB(15, 43, 213, 243),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color.fromRGBO(43, 213, 243, 1), width: 2),
                ),
              ),
              cursorColor: Color.fromRGBO(43, 213, 243, 1),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(43, 213, 243, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 1.5,
                ),
                icon: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                label: const Text("Unirse al curso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () async {
                  final code = codeController.text.trim();
                  if (code.isNotEmpty) {
                    final userId = auth.currentUser.value.id ?? "0";
                    final success = await courseCon.joinCourse(
                      courseCode: code,
                      userId: userId,
                    );
                    if (success) {
                      Get.snackbar(
                        "Éxito",
                        "Te has unido al curso éxitosamente.",
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    } else {
                      Get.snackbar(
                        "Error",
                        "Curso no existente o ya eres miembro",
                        icon: const Icon(Icons.error, color: Colors.red),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Error",
                      "El código no puede estar vacío",
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
