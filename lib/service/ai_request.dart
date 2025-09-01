import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/service/gemini_request.dart';
import 'package:vibcat/service/volcano_engine_request.dart';
import 'package:vibcat/util/file.dart';

import '../bean/upload_file.dart';
import 'openai_request.dart';

abstract class AIRequestService {
  final dio = Dio();

  AIRequestService() {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  /// 获取指定服务商的 AI 模型列表
  Future<List<AIModel>> getModelList({required AIModelConfig config});

  /// 流式返回
  Stream<ChatMessage?> chatCompletions({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  });

  /// 一次性返回，非流式
  Future<ChatMessage?> chatCompletionsOnce({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  });

  /// 工厂构造函数
  factory AIRequestService.create(AIModelConfig config) {
    // if (config.provider.compatibleOpenAI == true) {
    //   return OpenAIRequestService();
    // }

    switch (config.provider) {
      case AIProviderType.openAI:
      case AIProviderType.deepseek:
      case AIProviderType.siliconFlow:
      case AIProviderType.groq:
      case AIProviderType.openRouter:
      case AIProviderType.ollama:
        return OpenAIRequestService();
      case AIProviderType.gemini:
        return GeminiRequestService();
      case AIProviderType.volcanoEngine:
        return VolcanoEngineRequestService();
      case AIProviderType.azureOpenAI:
      case AIProviderType.claude:
        throw Exception('Unsupported AI provider: ${config.provider}');
      // default:
      //   throw Exception('Unsupported AI provider: ${config.provider}');
    }
  }

  Future<List> transformMessages(List<ChatMessage> messages) async =>
      await Future.wait(
        messages.map((item) async {
          if (item.files.isNotEmpty) {
            final contents = [
              {'type': 'text', 'text': item.content},
              ...await Future.wait(
                item.files.map((e) async {
                  if (e is UploadImage) {
                    return {
                      'type': 'image_url',
                      'image_url': {
                        'url': await FileUtil.fileToBase64DataUri(
                          e.file,
                          mimeType: e.mimeType,
                        ),
                      },
                    };
                  } else {
                    return {
                      'type': 'file',
                      'file': {
                        'file_data': await FileUtil.fileToBase64DataUri(
                          e.file,
                          mimeType: e.mimeType,
                        ),
                      },
                    };
                  }
                }),
              ),
            ];

            return {'role': item.role.name, 'content': contents};
          } else {
            return {'role': item.role.name, 'content': item.content};
          }
        }),
      );

  dynamic transformStream(Response<dynamic> response) {
    return response.data.stream
        // type 'Utf8Decoder' is not a subtype of type 'StreamTransformer<Uint8List, dynamic>' of 'streamTransformer'
        // or .map((chunk) => chunk.toList()) // Uint8List -> List<int>
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }
}
