import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CourseCodeBox extends StatelessWidget {
  final String courseCode;
  const CourseCodeBox({super.key, required this.courseCode});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.content_copy, size: 22),
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
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              const Text(
                "Comparte este código con tus estudiantes",
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
