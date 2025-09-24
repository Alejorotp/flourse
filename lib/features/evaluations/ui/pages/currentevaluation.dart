import 'package:flutter/material.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';

class CurrentEvaluationPage extends StatelessWidget {
  static const String id = '/evaluation-detail';
  final Evaluation evaluation;

  const CurrentEvaluationPage({super.key, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles de Evaluación"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre: ${evaluation.name}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "ID de Evaluación: ${evaluation.evaluationID}",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              "ID de Categoría: ${evaluation.categoryID}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Fecha de creación: ${evaluation.creationDate}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Visibilidad: ${evaluation.visibility}",
              style: const TextStyle(fontSize: 16),
            ),
            // Aquí podrías añadir un botón para 'Empezar Evaluación'
          ],
        ),
      ),
    );
  }
}
