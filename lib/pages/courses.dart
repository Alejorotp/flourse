import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  static const String id = '/courses';
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Courses Page"),
      ),
    );
  }
}