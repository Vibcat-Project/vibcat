import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/service/ai_request.dart';

class AINetRepository {
  Future<List<AIModel>> getModelList(AIModelConfig config) async {
    return AIRequestService.create(config).getModelList(config: config);
  }
}
