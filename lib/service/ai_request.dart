import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';

import 'openai_request.dart';

abstract class AIRequestService {
  final dio = Dio();

  AIRequestService() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// 获取指定服务商的 AI 模型列表
  Future<List<AIModel>> getModelList({required AIModelConfig config});

  /// 流式返回
  Stream<ChatMessage?> completions({
    required AIModelConfig config,
    required AIModel model,
    required List<ChatMessage> history,
  });

  /// 一次性返回，非流式
  Future<ChatMessage> completionsOnce({
    required AIModelConfig config,
    required AIModel model,
    required List<ChatMessage> history,
  });

  /// 工厂构造函数
  factory AIRequestService.create(AIModelConfig config) {
    if (config.provider.compatibleOpenAI == true) {
      return OpenAIRequestService();
    }

    switch (config.provider) {
      default:
        throw Exception('Unsupported AI provider: ${config.provider}');
    }
  }
}
