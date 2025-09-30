import 'package:flutter/material.dart';

class CreateCourseCard extends StatelessWidget {
  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  final VoidCallback onTap;
  const CreateCourseCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        highlightColor: Colors.deepPurpleAccent.withOpacity(0.12),
        splashColor: Colors.deepPurpleAccent.withOpacity(0.18),
        onTap: onTap,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(94, 239, 229, 248),
            border: Border.all(color: const Color.fromARGB(210, 216, 204, 226)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 32, color: lilac),
                SizedBox(height: 8),
                Text(
                  "Crear un curso",
                  style: TextStyle(
                    color: lilac,
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
