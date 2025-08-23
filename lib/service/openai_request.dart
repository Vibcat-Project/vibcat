import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/bean/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/service/ai_request.dart';

class OpenAIRequestService extends AIRequestService {
  @override
  Future<List<AIModel>> getModelList({required AIModelConfig config}) async {
    try {
      final res = await dio.get(
        '${config.endPoint}/models',
        options: Options(headers: {'Authorization': 'Bearer ${config.apiKey}'}),
      );
      if (res.statusCode != 200) {
        return [];
      }

      return (res.data['data'] as List)
          .map((e) => AIModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<String> completions({
    required AIModelConfig config,
    required List<ChatMessage> history,
  }) {
    // TODO: implement completions
    throw UnimplementedError();
  }

  @override
  Future<ChatMessage> completionsOnce({
    required AIModelConfig config,
    required List<ChatMessage> history,
  }) {
    // TODO: implement completionsOnce
    throw UnimplementedError();
  }
}
