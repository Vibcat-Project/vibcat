import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/global/models.dart';
import 'package:vibcat/service/gemini_request.dart';
import 'package:vibcat/service/volcano_engine_request.dart';
import 'package:vibcat/util/file.dart';

import '../bean/upload_file.dart';
import '../enum/ai_think_type.dart';
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
      // case AIProviderType.azureOpenAI:
      // case AIProviderType.claude:
      //   throw Exception('Unsupported AI provider: ${config.provider}');
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

  Future<Map<String, dynamic>> buildReqParams({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async {
    final params = <String, dynamic>{
      'model': model.id,
      'messages': await transformMessages(history),
      'stream': true,
      'stream_options': {'include_usage': true},
    };

    var thinkingParams = <String, dynamic>{};

    switch (config.provider) {
      case AIProviderType.openAI:
      case AIProviderType.deepseek:
      case AIProviderType.openRouter:
      case AIProviderType.ollama:
        if (conversation.thinkType != AIThinkType.none &&
            conversation.thinkType != AIThinkType.auto) {
          thinkingParams = {'reasoning_effort': conversation.thinkType.name};
        }
      case AIProviderType.groq:
        final gradient =
            ModelsConfig.supportThinkingControl[config.provider]?[model.id];

        if (gradient == null) {
          // 代表该模型不支持思考
          thinkingParams = {};
        } else if (gradient == true) {
          thinkingParams = {
            'reasoning_effort':
                conversation.thinkType == AIThinkType.none ||
                    conversation.thinkType == AIThinkType.auto
                ? 'medium'
                : conversation.thinkType.name,
          };
        } else {
          thinkingParams = {
            'reasoning_effort': conversation.thinkType == AIThinkType.none
                ? 'none'
                : 'default',
          };
        }
      case AIProviderType.siliconFlow:
        final gradient =
            ModelsConfig.supportThinkingControl[config.provider]?[model.id];

        if (gradient == null) {
          // 代表该模型不支持控制思考强度，且对于支持思考的模型，不能传入控制思考强度的参数
          thinkingParams = {};
        } else {
          var thinkingBudget = 4096;
          switch (conversation.thinkType) {
            case AIThinkType.low:
              thinkingBudget = 128;
              break;
            case AIThinkType.medium:
              thinkingBudget = 16320;
              break;
            case AIThinkType.high:
              thinkingBudget = 32768;
              break;
            default:
              thinkingBudget = 4096;
          }

          thinkingParams = {
            'enable_thinking': conversation.thinkType != AIThinkType.none,
            'thinking_budget': thinkingBudget,
          };
        }
      case AIProviderType.gemini:
        thinkingParams = {
          "extra_body": {
            "google": {
              "thinking_config": {
                "include_thoughts": conversation.thinkType != AIThinkType.none,
              },
            },
          },
        };
      case AIProviderType.volcanoEngine:
        final thinkingType = conversation.thinkType == AIThinkType.none
            ? 'disabled'
            : (conversation.thinkType == AIThinkType.auto ? 'auto' : 'enabled');

        thinkingParams = {
          "extra_body": {
            "thinking": {"type": thinkingType},
          },
        };
    }

    return params..addAll(thinkingParams);
  }
}
