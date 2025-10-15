import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

class ShowEvaluationPage extends StatelessWidget {
  final List<double> scores; // [puntualidad, contribuciones, compromiso, actitud]

  const ShowEvaluationPage({
    super.key,
    required this.scores,
  });

  String getPunctualityRubric(double value) {
    if (value < 3) {
      return "Llegó tarde a todas las sesiones o se ausentó constantemente.";
    } else if (value < 4) {
      return "Llegó tarde con mucha frecuencia y se ausentó varias veces del trabajo del equipo.";
    } else if (value < 5) {
      return "En la mayoría de las sesiones llegó puntualmente y no se ausentó con frecuencia.";
    } else {
      return "Acudió puntualmente a todas las sesiones de trabajo.";
    }
  }

  String getContributionsRubric(double value) {
    if (value < 3) {
      return "En todo momento estuvo como observador y no aportó al trabajo del equipo.";
    } else if (value < 4) {
      return "En algunas ocasiones participó dentro del equipo y en los intercambios generales.";
    } else if (value < 5) {
      return "Hizo varios aportes al equipo; sin embargo, puede ser más crítico y propositivo.";
    } else {
      return "Sus aportes fueron muy enriquecedores en todo momento al trabajo del equipo.";
    }
  }

  String getCommitmentRubric(double value) {
    if (value < 3) {
      return "Mostró poco compromiso con las tareas y roles asignados y en ocasiones no aportó en las tareas propuestas al equipo.";
    } else if (value < 4) {
      return "En algunos momentos asumió tareas y roles, pero en otros momentos no aportó en las tareas propuestas.";
    } else if (value < 5) {
      return "La mayor parte del tiempo asumió tareas con compromiso y responsabilidad y ha aportado más al trabajo del equipo.";
    } else {
      return "Mostró en todo momento un compromiso con las tareas asignadas y los roles que tuvo en el equipo.";
    }
  }

  String getAttitudeRubric(double value) {
    if (value < 3) {
      return "Actuó de manera pasiva y su actitud afectó negativamente las tareas y la colaboración.";
    } else if (value < 4) {
      return "En algunas ocasiones mostró actitud positiva y afectó positivamente el impacto en el equipo.";
    } else if (value < 5) {
      return "La mayor parte del tiempo mostró actitud positiva y buena disposición.";
    } else {
      return "Siempre mostró actitud positiva y disposición para colaborar con calidad.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double punctuality = scores[0];
    final double contributions = scores[1];
    final double commitment = scores[2];
    final double attitude = scores[3];

    logInfo("Showing evaluation with scores: $scores");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de la evaluación'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Promedios de desempeño",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[700],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _buildScoreCard(
                icon: Icons.access_time,
                iconColor: Colors.blue,
                label: "Puntualidad",
                value: punctuality,
                rubric: getPunctualityRubric(punctuality),
              ),
              _buildScoreCard(
                icon: Icons.group_work,
                iconColor: Colors.orange,
                label: "Contribuciones",
                value: contributions,
                rubric: getContributionsRubric(contributions),
              ),
              _buildScoreCard(
                icon: Icons.assignment_turned_in,
                iconColor: Colors.green,
                label: "Compromiso",
                value: commitment,
                rubric: getCommitmentRubric(commitment),
              ),
              _buildScoreCard(
                icon: Icons.emoji_emotions,
                iconColor: Colors.purple,
                label: "Actitud",
                value: attitude,
                rubric: getAttitudeRubric(attitude),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required double value,
    required String rubric,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.15),
              child: Icon(icon, color: iconColor, size: 28),
              radius: 26,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$label: ${value.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rubric,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
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