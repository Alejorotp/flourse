import 'package:flutter/material.dart';

class ProfessorBox extends StatelessWidget {
  final String professorName;
  const ProfessorBox({super.key, required this.professorName});

  @override
  Widget build(BuildContext context) {
    const lilac = Color.fromRGBO(124, 77, 255, 1);
    final chipBg = lilac.withOpacity(0.12);
    final cardBg = Theme.of(context).cardColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color.fromARGB(255, 232, 212, 255), // lilac muy suave
                  child: Text(
                    (professorName.isNotEmpty ? professorName[0] : '?').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: lilac,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: lilac,
                      shape: BoxShape.circle,
                      border: Border.all(color: cardBg, width: 2),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Profesor del curso',
                          style: TextStyle(
                            color: lilac,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Nombre del profesor
                  Text(
                    professorName.isNotEmpty ? professorName : 'Sin nombre',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}