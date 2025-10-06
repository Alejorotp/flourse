import 'package:flutter/material.dart';
import '../../domain/models/evaluation.dart';

class EvaluationListCard extends StatelessWidget {
  final Evaluation evaluation;
  final VoidCallback? onTap;
  const EvaluationListCard({
    super.key,
    required this.evaluation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define el tamaño cuadrado (ajusta Y según tu preferencia, por ejemplo 140)
    const double cardSize = 140;

    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 205, 237, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.assignment, color: Color.fromRGBO(43, 213, 243, 1), size: 32),
                ),
                const SizedBox(height: 10),
                Text(
                  evaluation.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${evaluation.evaluationID}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        evaluation.visibility,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}