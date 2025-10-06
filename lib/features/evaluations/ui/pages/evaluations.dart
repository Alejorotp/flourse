import 'package:flourse/features/evaluations/ui/controller/evaluation_controller.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';
import 'package:flourse/features/evaluations/ui/pages/currentevaluation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/evaluation_list_simplecard.dart';

class EvaluationsPage extends StatefulWidget {
  static const String id = '/evaluations';
  const EvaluationsPage({super.key});


  @override
  State<EvaluationsPage> createState() => _EvaluationsPageState();
}

class _EvaluationsPageState extends State<EvaluationsPage> {
  @override
  Widget build(BuildContext context) {
    final EvaluationController evalCon = Get.find();
    final AuthenticationController auth = Get.find();
    evalCon.getUserEvaluations(auth.currentUser.value.id ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluaciones"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis evaluaciones',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(thickness: 0.15, color: Colors.grey),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final allEvals = evalCon.evaluations;
                if (allEvals.isEmpty) {
                  return const Center(
                    child: Text('No tienes evaluaciones pendientes.'),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: allEvals.length,
                  itemBuilder: (context, index) {
                    final eval = allEvals[index];
                    return EvaluationListCard(
                      evaluation: eval,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CurrentEvaluationPage(evaluation: eval, isProfessor: false,)));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}