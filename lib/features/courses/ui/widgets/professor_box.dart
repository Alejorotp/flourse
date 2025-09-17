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
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Professor", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(professorName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}