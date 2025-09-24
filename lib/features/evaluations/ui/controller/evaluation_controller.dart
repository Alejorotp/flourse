import 'package:get/get.dart';
import '../../domain/models/evaluation.dart';
import 'package:loggy/loggy.dart';
import '../../domain/use_case/evaluation_usecase.dart';

class EvaluationController extends GetxController {
  final EvaluationUseCase evasation;
  EvaluationController(this.evasation);

  final RxList<Evaluation> evaluations = <Evaluation>[].obs;


  Future<void> fetchEvaluationsByCategory(String categoryId) async {
    final fetchedEvaluations = await evasation.getByCategoryID(categoryId);
    evaluations.assignAll(fetchedEvaluations);
    logInfo("Fetched evaluations in Controller: ${fetchedEvaluations.length}");
  }

  Future<void> fetchAllEvaluations() async {
    final fetchedEvaluations = await evasation.getAllEval();
    evaluations.assignAll(fetchedEvaluations);
    logInfo("Fetched all evaluations in Controller: ${fetchedEvaluations.length}");
  }

  void createEvaluation({
    required String name,
    required String categoryId,
    required String visibility,
    required String creationDate,
  }) {
    evasation.createEvaluation(name: name, categoryId: categoryId, visibility: visibility, creationDate: creationDate);
  }

  List<Evaluation> getAllEvaluations() {
    return evaluations;
  }

  String getEvaluationById(String id) {
    final evaluation = evaluations.firstWhere(
      (evaluation) => evaluation.evaluationID == id,
      orElse: () => Evaluation(
        evaluationID: '',
        name: 'Unknown Evaluation',
        categoryID: '',
        visibility: '',
        creationDate: '',
      ),
    );
    return evaluation.name;
  }


}