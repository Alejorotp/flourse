import 'package:flourse/features/evaluations/domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/domain/models/score.dart';



abstract class IEvaluationSource {

  Future<List<Evaluation>> getByCategoryID(String categoryId, String accessToken);

  Future<List<Evaluation>> getAllEval(String accessToken);

  Future<void> createEvaluation({required String name, required String categoryId, required String visibility, required String creationDate, required String accessToken});

  Future<List<Evaluation>> getUserEvaluations(String userId, String accessToken);

  Future<List<String?>> getScoresByEvaluationID(String evaluationId, String accessToken);

  Future<List<String?>> getScoresByGroupID(String groupId, String evaluationId, String accessToken);

  Future<List<String?>> getScoresByCategoryID(String categoryId, String evaluationId, String accessToken);

  Future<List<String?>> getUserScores(String userId, String evaluationId, String accessToken);

  Future<List<String?>> getAllUserScores(String userId, String accessToken);

  Future<void> submitScore({required String userId, required String evaluationId, required String groupID, required String categoryID, required Score scores, required String accessToken});

}
