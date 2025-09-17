import 'package:flutter/material.dart';

typedef RoleToggleCallback = void Function(bool isProfessor);

class RoleToggleButtons extends StatelessWidget {
  final bool isProfessor;
  final RoleToggleCallback onChanged;
  const RoleToggleButtons({super.key, required this.isProfessor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isProfessor
            ? ElevatedButton(
                onPressed: () => onChanged(true),
                child: const Text('Professor'),
              )
            : OutlinedButton(
                onPressed: () => onChanged(true),
                child: const Text('Professor'),
              ),
        const SizedBox(width: 8),
        !isProfessor
            ? ElevatedButton(
                onPressed: () => onChanged(false),
                child: const Text('Student'),
              )
            : OutlinedButton(
                onPressed: () => onChanged(false),
                child: const Text('Student'),
              ),
      ],
    );
  }
}
