
import '../../domain/repositories/i_evaluation_repository.dart';
import '../datasources/i_evaluation_source.dart';
import '../../domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/domain/models/score.dart';



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
  Future<List<Evaluation>> getUserEvaluations(String userId) {
    return evalSource.getUserEvaluations(userId);
  }


  @override
  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate, required String accessToken}) {
    return evalSource.createEvaluation(name: name, categoryId: categoryId, visibility: visibility, creationDate: creationDate, accessToken: accessToken);
}

  @override
  Future<List<String?>> getScoresByEvaluationID(String evaluationId) {
    return evalSource.getScoresByEvaluationID(evaluationId);
  }

  @override
  Future<List<String?>> getScoresByGroupID(String groupId, String evaluationId, String accessToken) {
    return evalSource.getScoresByGroupID(groupId, evaluationId, accessToken);
  }

  @override
  Future<List<String?>> getScoresByCategoryID(String categoryId, String evaluationId) {
    return evalSource.getScoresByCategoryID(categoryId, evaluationId);
  }

  @override
  Future<List<String?>> getUserScores(String userId, String evaluationId) {
    return evalSource.getUserScores(userId, evaluationId);
  }

  @override
  Future<List<String?>> getAllUserScores(String userId) {
    return evalSource.getAllUserScores(userId);
  }

  @override
  Future<void> submitScore({required String userId, required String evaluationId, required String groupID, required String categoryID, required Score scores, required String accessToken}) {
    return evalSource.submitScore(userId: userId, evaluationId: evaluationId, groupID: groupID, categoryID: categoryID, scores: scores, accessToken: accessToken);
  }

}
