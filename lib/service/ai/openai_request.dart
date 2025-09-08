import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/enum/chat_message_type.dart';
import 'package:vibcat/service/ai/ai_request.dart';

import '../../data/schema/conversation.dart';
import '../../global/models.dart';

class OpenAIRequestService extends AIRequestService {
  @override
  final AIModelConfig config;
  @override
  final AIModel model;
  @override
  final Conversation conversation;
  @override
  final List<ChatMessage> history;
  @override
  Map<String, Object>? additionalParams;

  OpenAIRequestService({
    required this.config,
    required this.model,
    required this.conversation,
    required this.history,
    this.additionalParams,
  });

  @override
  Future<List<AIModel>> getModelList() async {
    try {
      final res = await httpClient.get(
        '${config.endPoint}/models',
        headers: {'Authorization': 'Bearer ${config.apiKey}'},
      );
      if (!res.isSuccess || res.data == null) {
        return [];
      }

      return (res.data['data'] as List).map((e) {
        // Gemini 获取模型列表的结果会包含 “models/” 前缀
        if (e['id'] != null && e['id'].toString().startsWith('models/')) {
          e['id'] = e['id'].toString().replaceFirst('models/', '');
        }
        return AIModel.fromJson(e);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<ChatMessage?> chatCompletions() async* {
    try {
      final res = await httpClient.post(
        '${config.endPoint}/chat/completions',
        body: await buildReqParams(),
        headers: {'Authorization': 'Bearer ${config.apiKey}'},
        responseType: ResponseType.stream,
      );

      if (!res.isSuccess || res.data == null) {
        yield null;
        return;
      }

      final stream = transformStream(res.raw);

      var thinkFinished = true;

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          print(line);

          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') break;

          final Map<String, dynamic> data = jsonDecode(jsonStr);
          final resultMsg = ChatMessage()..type = ChatMessageType.text;

          // 提取 Token Usage
          final usage = data['usage'];
          if (usage != null) {
            yield ChatMessage()
              ..type = ChatMessageType.usage
              ..tokenOutput = usage['completion_tokens'] ?? 0
              ..tokenInput = usage['prompt_tokens'] ?? 0
              ..tokenReasoning =
                  usage['completion_tokens_details']?['reasoning_tokens'] ?? 0;
          }

          if (data['choices']?.isEmpty ?? true) {
            continue;
          }

          final content = data['choices'][0]['delta']?['content'];
          final reasoning = data['choices'][0]['delta']?['reasoning_content'];

          // 针对 SiliconFlow, DeepSeek
          if (reasoning != null) {
            yield resultMsg..reasoning = reasoning;
            continue;
          }

          if (content != null) {
            if (content == "<think>") {
              thinkFinished = false;
              continue;
            }
            if (content == "</think>") {
              thinkFinished = true;
              continue;
            }

            if (thinkFinished) {
              yield resultMsg..content = content;
            } else {
              yield resultMsg..reasoning = content;
            }
          }
        }
      }
    } catch (e) {
      yield null;
    }
  }

  @override
  Future<ChatMessage?> chatCompletionsOnce() async {
    final data = {
      'model': model.id,
      'messages': await transformMessages(history),
      'stream': false,
      'stream_options': {'include_usage': true},
    };
    if (ModelsConfig.supportThinkingControl[AIProviderType.groq]?[model.id] !=
        null) {
      data.addAll({'reasoning_format': 'parsed'});
    }
    if (additionalParams != null) {
      data.addAll(additionalParams!);
    }

    final res = await httpClient.post(
      '${config.endPoint}/chat/completions',
      body: data,
      headers: {'Authorization': 'Bearer ${config.apiKey}'},
    );
    if (!res.isSuccess || res.data == null) {
      return null;
    }

    final resultMsg = ChatMessage();

    // 提取 Token Usage
    final usage = res.data['usage'];
    if (usage != null) {
      resultMsg
        ..tokenOutput = usage['completion_tokens'] ?? 0
        ..tokenInput = usage['prompt_tokens'] ?? 0;
    }

    if (res.data['choices']?.isEmpty ?? true) {
      return resultMsg;
    }

    final content = res.data['choices'][0]['message']?['content'];
    return resultMsg..content = content;
  }
}
