import 'package:flutter/material.dart';

class ProfessorBox extends StatelessWidget {
  final String professorName;
  const ProfessorBox({super.key, required this.professorName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.menu_book_rounded)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Profesor", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(79, 47, 167, 1))),
                Text(professorName, style: TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}