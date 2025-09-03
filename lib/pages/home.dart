import 'package:flutter/material.dart';
import 'package:flourse/data.dart'; // Importa el archivo de datos compartidos
import 'package:flourse/pages/courses.dart';
import 'package:flourse/pages/evaluations.dart';
import 'package:flourse/pages/currentevaluation.dart';
import 'package:flourse/classes/evaluation.dart';
import 'package:flourse/widgets/course_card.dart'; // El widget CourseCard

class HomePage extends StatelessWidget {
  static const String id = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flourse"),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.settings),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Courses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Courses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CoursesPage.id);
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myCourses.length,
                itemBuilder: (context, index) {
                  final course = myCourses[index];
                  // Llama al widget y le pasa el contexto y el objeto `course`
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CourseCard(course: course),
                  );
                },
              ),
            ),

            // Upcoming Evaluations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming evaluations",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(EvaluationsPage.id);
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Upcoming Evaluations
            Column(
              children: upcomingEvaluations.map((evaluation) {
                // Llama al widget y le pasa el contexto y el objeto `evaluation`
                return _evaluationItem(context, evaluation);
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Quick Access
            const Text(
              "Quick Access",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickAccessItem("Last Course"),
                _QuickAccessItem("Last Course +1"),
                _QuickAccessItem("Last Course +2"),
                _QuickAccessItem(""),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _evaluationItem(BuildContext context, Evaluation evaluation) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrentEvaluationPage(evaluation: evaluation),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.settings, color: Colors.grey),
        ),
        title: Text('${evaluation.title} · ${evaluation.course}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evaluation.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              evaluation.timeRemaining,
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ],
        ),
        trailing: const Icon(Icons.play_arrow),
      ),
    ),
  );
}

class _QuickAccessItem extends StatelessWidget {
  final String label;
  const _QuickAccessItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.folder, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
