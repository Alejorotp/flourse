import 'package:flutter/material.dart';

class JoinCourseCard extends StatelessWidget {
  final VoidCallback onTap;
  const JoinCourseCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        highlightColor: Colors.lightBlueAccent.withOpacity(0.12),
        splashColor: Colors.lightBlueAccent.withOpacity(0.18),
        onTap: onTap,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(15, 33, 149, 243),
            border: Border.all(color: Colors.lightBlueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_add_alt_1_outlined, size: 32, color: Colors.lightBlueAccent),
                SizedBox(height: 8),
                Text(
                  "Unirse a un curso",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
