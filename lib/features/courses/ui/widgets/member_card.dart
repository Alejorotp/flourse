import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String name;
  const MemberCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
      ),
    );
  }
}