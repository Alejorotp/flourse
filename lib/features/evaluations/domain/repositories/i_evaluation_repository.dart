//import '../../domain/models/course.dart';
import '../../domain/models/evaluation.dart';

abstract class IEvaluationRepository {
  Future<List<Evaluation>> getByCategoryID(String categoryId);

  Future<List<Evaluation>> getAllEval();

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate});

}
