import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String name;
  const MemberCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none, // evita recortar el ícono pequeño
          children: [
            CircleAvatar(
              radius: 20, // mismo tamaño que el avatar del profesor
              backgroundColor: const Color.fromARGB(255, 205, 237, 255),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: const TextStyle(
                  color: Color.fromRGBO(43, 213, 243, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(43, 213, 243, 1), // azul de fondo
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 250, 247, 252), // color del fondo del card
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(
                  Icons.person,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}