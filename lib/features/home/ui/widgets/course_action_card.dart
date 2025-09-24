import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseActionCard extends StatelessWidget {
  const CourseActionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // mismo ancho que CourseCard
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(94, 239, 229, 248),
          border: Border.all(color: const Color.fromARGB(210, 216, 204, 226)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.add_circle_outline,
                label: "Crear un curso",
                color: Colors.deepPurpleAccent,
                onTap: () {
                  Get.toNamed("/create-course");
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _ActionButton(
                icon: Icons.person_add_alt_1_outlined,
                label: "Unirse a un curso",
                color: Colors.lightBlueAccent,
                onTap: () {
                  Get.toNamed("/join-course");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
