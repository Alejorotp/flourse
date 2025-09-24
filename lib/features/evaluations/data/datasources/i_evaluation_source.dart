import 'package:flourse/features/evaluations/domain/models/evaluation.dart';



abstract class IEvaluationSource {

  Future<List<Evaluation>> getByCategoryID(String categoryId);

  Future<List<Evaluation>> getAllEval();

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate});
}
