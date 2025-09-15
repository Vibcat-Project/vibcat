import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/service/ai/ai_request.dart';
import 'package:vibcat/service/ai/params_builder/builder.dart';

import '../../bean/chat_request.dart';
import '../../global/models.dart';

class OpenAIRequestService extends AIRequestService {
  @override
  final ChatRequest request;

  bool _thinkFinished = true;

  OpenAIRequestService(this.request);

  @override
  Future<List<AIModel>> getModelList() async {
    try {
      final res = await httpClient.get(
        '${request.config.endPoint}/models',
        headers: {'Authorization': 'Bearer ${request.config.apiKey}'},
        cancelToken: request.cancelToken,
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
  Stream<ChatResponse> parseStreamData(Map<String, dynamic> data) async* {
    final usage = data['usage'];
    if (usage != null) {
      yield ChatResponse(
        type: ChatResponseType.usage,
        tokenUsage: TokenUsage(
          input: usage['prompt_tokens'] ?? 0,
          output: usage['completion_tokens'] ?? 0,
          reasoning:
              usage['completion_tokens_details']?['reasoning_tokens'] ?? 0,
        ),
      );
    }

    if (data['choices']?.isEmpty ?? true) {
      return;
    }

    final delta = data['choices'][0]['delta'];
    if (delta == null) return;

    final content = delta['content'];
    final reasoning = delta['reasoning_content'];

    if (reasoning != null) {
      yield ChatResponse(
        type: ChatResponseType.reasoning,
        reasoning: reasoning,
      );
      return;
    }

    if (content != null) {
      if (content == "<think>") {
        _thinkFinished = false;
        return;
      }
      if (content == "</think>") {
        _thinkFinished = true;
        return;
      }

      if (_thinkFinished) {
        yield ChatResponse(type: ChatResponseType.content, content: content);
      } else {
        yield ChatResponse(
          type: ChatResponseType.reasoning,
          reasoning: content,
        );
      }
    }
  }

  @override
  Future<ChatResponse> chatCompletionsOnce() async {
    final data = await ChatRequestParamsBuilder.build(
      request,
      stream: false,
      ignoreThinking: true,
    );
    if (ModelsConfig.supportThinkingControl[AIProviderType.groq]?[request
            .model
            .id] !=
        null) {
      data.addAll({'reasoning_format': 'parsed'});
    }

    final res = await httpClient.post(
      '${request.config.endPoint}/chat/completions',
      body: data,
      headers: {'Authorization': 'Bearer ${request.config.apiKey}'},
      cancelToken: request.cancelToken,
    );
    if (!res.isSuccess || res.data == null) {
      if (res.raw is DioException && CancelToken.isCancel(res.raw)) {
        return ChatResponse(type: ChatResponseType.content);
      } else {
        return ChatResponse(type: ChatResponseType.error, content: res.message);
      }
    }

    ChatResponse response = ChatResponse(type: ChatResponseType.content);

    // 提取 Token Usage
    final usage = res.data['usage'];
    if (usage != null) {
      response = response.copyWith(
        tokenUsage: TokenUsage(
          input: usage['prompt_tokens'] ?? 0,
          output: usage['completion_tokens'] ?? 0,
          reasoning: 0,
        ),
      );
    }

    if (res.data['choices']?.isEmpty ?? true) {
      return response.copyWith(type: ChatResponseType.error);
    }

    final content = res.data['choices'][0]['message']?['content'];
    return response.copyWith(content: content);
  }
}
