import '../repositories/i_evaluation_repository.dart';
import '../models/evaluation.dart';

class EvaluationUseCase {
  final IEvaluationRepository _repository;

  EvaluationUseCase(this._repository);

  Future<List<Evaluation>> getByCategoryID(String categoryId) async =>
      await _repository.getByCategoryID(categoryId);

  Future<List<Evaluation>> getAllEval() async => await _repository.getAllEval();

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate}) async =>
      await _repository.createEvaluation(name: name, categoryId: categoryId, visibility
: visibility, creationDate: creationDate);

}
