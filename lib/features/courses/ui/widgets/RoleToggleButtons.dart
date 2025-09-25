import 'package:flutter/material.dart';

typedef RoleToggleCallback = void Function(bool isProfessor);

class RoleToggleButtons extends StatelessWidget {
  final bool isProfessor;
  final RoleToggleCallback onChanged;
  const RoleToggleButtons({super.key, required this.isProfessor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
    const blue = Color.fromRGBO(43, 213, 243, 1); // celeste
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 30,
            child: isProfessor
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lilac,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => onChanged(true),
                    child: const Text('Profesor'),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: lilac,
                      side: BorderSide(color: lilac),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => onChanged(true),
                    child: const Text('Profesor'),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 30,
            child: !isProfessor
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => onChanged(false),
                    child: const Text('Estudiante'),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blue,
                      side: BorderSide(color: blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => onChanged(false),
                    child: const Text('Estudiante'),
                  ),
          ),
        ),
      ],
    );
  }
}
