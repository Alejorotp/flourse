import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String name;
  const MemberCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 205, 237, 255),
          child: Icon(Icons.person, color: Color.fromRGBO(43, 213, 243, 1)),
        ),
        title: Text(name, style: TextStyle(fontSize: 17)),
      ),
    );
  }
}