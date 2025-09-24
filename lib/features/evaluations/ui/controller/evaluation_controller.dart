import 'package:get/get.dart';
import '../../domain/models/evaluation.dart';
import 'package:flourse/features/evaluations/domain/models/score.dart';
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

  Future<List<Evaluation>> getUserEvaluations(String userId) {
    return evasation.getUserEvaluations(userId);
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

  Future<List<String?>> getScoresByCategoryID(String categoryId, String evaluationId) {
    return evasation.getScoresByCategoryID(categoryId, evaluationId);
  }

  Future<List<String?>> getScoresByEvaluationID(String evaluationId) {
    return evasation.getScoresByEvaluationID(evaluationId);
  }

  Future<List<String?>> getScoresByGroupID(String groupId, String evaluationId) {
    return evasation.getScoresByGroupID(groupId, evaluationId);
  }

  Future<void> submitScore({
    required String userId,
    required String evaluationId,
    required String groupID,
    required String categoryID,
    required Score scores,
  }) {
    return evasation.submitScore(userId: userId, evaluationId: evaluationId, groupID: groupID, categoryID: categoryID, scores: scores);
  }

  Future<List<String?>> getUserScores(String userId, String evaluationId) {
    return evasation.getUserScores(userId, evaluationId);
  }

  Future<List<String?>> getAllUserScores(String userId) {
    return evasation.getAllUserScores(userId);
  }


    









}