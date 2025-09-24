
import '../../domain/repositories/i_evaluation_repository.dart';
import '../datasources/i_evaluation_source.dart';
import '../../domain/models/evaluation.dart';



class EvaluationRepository implements IEvaluationRepository {
  late IEvaluationSource evalSource;

  EvaluationRepository(this.evalSource);

  @override
  Future<List<Evaluation>> getByCategoryID(String categoryId) {
    return evalSource.getByCategoryID(categoryId);
  }

  @override
  Future<List<Evaluation>> getAllEval() {
    return evalSource.getAllEval();
  }

  @override
  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate}) {
    return evalSource.createEvaluation(name: name, categoryId: categoryId, visibility
: visibility, creationDate: creationDate);
}


}
