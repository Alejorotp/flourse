import 'package:flutter/material.dart';
import 'package:flourse/classes/evaluation.dart';

class CurrentEvaluationPage extends StatelessWidget {
  static const String id = '/evaluation-detail';
  final Evaluation evaluation;

  const CurrentEvaluationPage({super.key, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluation Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${evaluation.title}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Course: ${evaluation.course}",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(evaluation.description),
            const SizedBox(height: 16),
            Text(
              "Time Remaining: ${evaluation.timeRemaining}",
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            // Aquí podrías añadir un botón para 'Empezar Evaluación'
          ],
        ),
      ),
    );
  }
}