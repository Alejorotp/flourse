import '../repositories/i_evaluation_repository.dart';
import '../models/evaluation.dart';
import 'package:flourse/features/evaluations/domain/models/score.dart';

class EvaluationUseCase {
  final IEvaluationRepository _repository;

  EvaluationUseCase(this._repository);

  Future<List<Evaluation>> getByCategoryID(String categoryId) async =>
      await _repository.getByCategoryID(categoryId);

  Future<List<Evaluation>> getAllEval() async => await _repository.getAllEval();

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate}) async =>
      await _repository.createEvaluation(name: name, categoryId: categoryId, visibility
: visibility, creationDate: creationDate);

  Future<List<Evaluation>> getUserEvaluations(String userId) async =>
      await _repository.getUserEvaluations(userId);

  Future<List<String?>> getScoresByEvaluationID(String evaluationId) async =>
      await _repository.getScoresByEvaluationID(evaluationId);

  Future<List<String?>> getScoresByGroupID(String groupId, String evaluationId) async =>
      await _repository.getScoresByGroupID(groupId, evaluationId);

  Future<List<String?>> getScoresByCategoryID(String categoryId, String evaluationId) async =>
      await _repository.getScoresByCategoryID(categoryId, evaluationId);

  Future<List<String?>> getUserScores(String userId, String evaluationId) async =>
      await _repository.getUserScores(userId, evaluationId);

  Future<List<String?>> getAllUserScores(String userId) async =>
      await _repository.getAllUserScores(userId);

  Future<void> submitScore({required String userId, required String evaluationId, required String groupID, required String courseID, required String categoryID, required Score scores, required String evaluatorId}) async =>
      await _repository.submitScore(userId: userId, evaluationId: evaluationId, courseID: courseID, groupID: groupID, categoryID: categoryID, scores: scores, evaluatorId: evaluatorId);

}
