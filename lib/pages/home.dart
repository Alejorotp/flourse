import 'package:flutter/material.dart';
import 'package:flourse/data.dart'; // Importa el archivo de datos compartidos
import 'package:flourse/pages/courses.dart';
import 'package:flourse/pages/evaluations.dart';

// ... (elimina las listas myCourses y upcomingEvaluations de este archivo)

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
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _courseCard(
                      course.title,
                      course.role,
                      '${course.members} Members',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

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
            // Utiliza la lista de datos compartidos
            Column(
              children: upcomingEvaluations
                  .map((evaluation) => _evaluationItem(
                        '${evaluation.title} · ${evaluation.course}',
                        evaluation.description,
                        evaluation.timeRemaining,
                      ))
                  .toList(),
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
                _quickAccessItem("Last Course"),
                _quickAccessItem("Last Course +1"),
                _quickAccessItem("Last Course +2"),
                _quickAccessItem(""),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Widget _courseCard(String title, String role, String members) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(role),
        Text(members),
        const SizedBox(height: 8),
        Row(
          children: const [
            CircleAvatar(radius: 12),
            SizedBox(width: 4),
            CircleAvatar(radius: 12),
          ],
        ),
      ],
    ),
  );
}

Widget _evaluationItem(String title, String subtitle, String time) {
  return Card(
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
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.blue)),
        ],
      ),
      trailing: const Icon(Icons.play_arrow),
    ),
  );
}

class _quickAccessItem extends StatelessWidget {
  final String label;
  const _quickAccessItem(this.label);

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
