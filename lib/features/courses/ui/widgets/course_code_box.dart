import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CourseCodeBox extends StatelessWidget {
  final String courseCode;
  const CourseCodeBox({super.key, required this.courseCode});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF3E5F5),
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Código del curso",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(79, 47, 167, 1)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.content_copy, size: 22, color: Color.fromRGBO(79, 47, 167, 1)),
                    tooltip: "Copiar código",
                    onPressed: () async {
                      await _copyToClipboard(context, courseCode);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SelectableText(
                courseCode,
                style: const TextStyle(fontSize: 18, color: Color.fromRGBO(124, 77, 255, 1), fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 4),
              const Text(
                "Comparte este código con tus estudiantes",
                style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 148, 148, 148)),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _copyToClipboard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  Get.snackbar(
    "Éxito",
    "Código copiado al portapapeles",
    icon: const Icon(Icons.copy, color: Colors.green),
    snackPosition: SnackPosition.BOTTOM,
    );
}
}
