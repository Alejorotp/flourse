import 'package:flutter/material.dart';

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
            const Text(
              "My Courses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _courseCard("Course", "Role", "n Members")),
                const SizedBox(width: 12),
                Expanded(child: _courseCard("Course", "Role", "m Members")),
              ],
            ),
            const SizedBox(height: 24),

            // Upcoming Evaluations
            const Text(
              "Upcoming evaluations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _evaluationItem(
              "Title · Course A",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
              "Today · 23 min",
            ),
            _evaluationItem(
              "Title · Course B",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
              "Tomorrow · 23h 23 min",
            ),
            _evaluationItem(
              "Title · Course B",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
              "2 Days Left · 47h 23 min",
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