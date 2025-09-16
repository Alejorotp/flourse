import 'package:flutter/material.dart';

class EvaluationsPage extends StatelessWidget {
  static const String id = '/evaluations';
  const EvaluationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluations"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Evaluations Page"),
      ),
    );
  }
}