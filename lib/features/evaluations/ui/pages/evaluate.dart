import 'package:flourse/features/courses/ui/controller/courses_controller.dart';
import 'package:flourse/features/reports/ui/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/features/evaluations/domain/models/score.dart';
import 'package:flourse/features/evaluations/ui/controller/evaluation_controller.dart';
import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:loggy/loggy.dart';

class EvaluatePage extends StatefulWidget {
  final String teammateId;
  final String teammateName;
  final Evaluation evaluation;
  final String groupID;

  const EvaluatePage({
    super.key,
    required this.teammateId,
    required this.teammateName,
    required this.evaluation,
    required this.groupID,
  });

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  EvaluationController evaluationController = Get.find();
  AuthenticationController auth = Get.find();
  ReportController reportController = Get.find();
  CoursesController coursesController = Get.find();

  double punctuality = 3.0;
  double contributions = 3.0;
  double commitment = 3.0;
  double attitude = 3.0;

  String getPunctualityRubric(double value) {
    if (value < 2.5) {
      return "Llegó tarde a todas las sesiones o se ausentó constantemente.";
    } else if (value < 3.5) {
      return "Llegó tarde con mucha frecuencia y se ausentó varias veces del trabajo del equipo.";
    } else if (value < 4.5) {
      return "En la mayoría de las sesiones llegó puntualmente y no se ausentó con frecuencia.";
    } else {
      return "Acudió puntualmente a todas las sesiones de trabajo.";
    }
  }

  String getContributionsRubric(double value) {
    if (value < 2.5) {
      return "En todo momento estuvo como observador y no aportó al trabajo del equipo.";
    } else if (value < 3.5) {
      return "En algunas ocasiones participó dentro del equipo y en los intercambios generales.";
    } else if (value < 4.5) {
      return "Hizo varios aportes al equipo; sin embargo, puede ser más crítico y propositivo.";
    } else {
      return "Sus aportes fueron muy enriquecedores en todo momento al trabajo del equipo.";
    }
  }

  String getCommitmentRubric(double value) {
    if (value < 2.5) {
      return "Mostró poco compromiso con las tareas y roles asignados y en ocasiones no aportó en las tareas propuestas al equipo.";
    } else if (value < 3.5) {
      return "En algunos momentos asumió tareas y roles, pero en otros momentos no aportó en las tareas propuestas.";
    } else if (value < 4.5) {
      return "La mayor parte del tiempo asumió tareas con compromiso y responsabilidad y ha aportado más al trabajo del equipo.";
    } else {
      return "Mostró en todo momento un compromiso con las tareas asignadas y los roles que tuvo en el equipo.";
    }
  }

  String getAttitudeRubric(double value) {
    if (value < 2.5) {
      return "Actuó de manera pasiva y su actitud afectó negativamente las tareas y la colaboración.";
    } else if (value < 3.5) {
      return "En algunas ocasiones mostró actitud positiva y afectó positivamente el impacto en el equipo.";
    } else if (value < 4.5) {
      return "La mayor parte del tiempo mostró actitud positiva y buena disposición.";
    } else {
      return "Siempre mostró actitud positiva y disposición para colaborar con calidad.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current user has already scored this teammate for this evaluation
    final currentUserId = auth.currentUser.value.id!;
     List<String>? score = reportController.getScore(
      widget.teammateId,
      currentUserId,
      widget.evaluation.evaluationID,
    );
    logInfo("Score fetched: $score");

    bool alreadyScored = score != null;

    logInfo(alreadyScored);

    if (alreadyScored) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Evaluar a ${widget.teammateName}'),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Ya has evaluado a este compañero para esta actividad.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Evaluar a ${widget.teammateName}'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Evalúa a tu compañero",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  label: "Puntualidad",
                  value: punctuality,
                  rubric: getPunctualityRubric(punctuality),
                  onChanged: (v) => setState(() => punctuality = v),
                ),
                _buildSlider(
                  label: "Contribuciones",
                  value: contributions,
                  rubric: getContributionsRubric(contributions),
                  onChanged: (v) => setState(() => contributions = v),
                ),
                _buildSlider(
                  label: "Compromiso",
                  value: commitment,
                  rubric: getCommitmentRubric(commitment),
                  onChanged: (v) => setState(() => commitment = v),
                ),
                _buildSlider(
                  label: "Actitud",
                  value: attitude,
                  rubric: getAttitudeRubric(attitude),
                  onChanged: (v) => setState(() => attitude = v),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final score = Score(
                        punctuality: punctuality.toStringAsFixed(1),
                        contributions: contributions.toStringAsFixed(1),
                        commitment: commitment.toStringAsFixed(1),
                        attitude: attitude.toStringAsFixed(1),
                      );
                      evaluationController.submitScore(
                        userId: widget.teammateId,
                        courseID: coursesController.getCurrentCourseId()!,
                        evaluationId: widget.evaluation.evaluationID,
                        evaluatorID: currentUserId,
                        groupID: widget.groupID,
                        categoryID: widget.evaluation.categoryID,
                        scores: score,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Evaluación enviada para ${widget.teammateName}',
                          ),
                        ),
                      );
                      reportController.fetchAllReports(courseId:  coursesController.getCurrentCourseId()!);
                      Get.back(); // Vuelve a la página anterior
                    },
                    child: const Text('Enviar Evaluación'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required String rubric,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(1)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            rubric,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
        Slider(
          value: value,
          min: 1.0,
          max: 5.0,
          divisions: 40,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
