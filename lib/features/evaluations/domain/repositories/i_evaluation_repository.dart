import 'package:flourse/features/evaluations/domain/models/score.dart';
import '../../domain/models/evaluation.dart';

abstract class IEvaluationRepository {
  Future<List<Evaluation>> getByCategoryID(String categoryId);

  Future<List<Evaluation>> getAllEval();

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate});

  Future<List<String?>> getScoresByEvaluationID(String evaluationId);

  Future<List<String?>> getScoresByGroupID(String groupId, String evaluationId);

  Future<List<String?>> getScoresByCategoryID(String categoryId, String evaluationId);

  Future<List<String?>> getUserScores(String userId, String evaluationId);

  Future<List<String?>> getAllUserScores(String userId);

  Future<void> submitScore({required String userId, required String evaluationId, required String groupID, required String categoryID, required Score scores});

}
