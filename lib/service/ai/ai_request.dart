import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vibcat/bean/chat_request.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/service/ai/gemini_request.dart';
import 'package:vibcat/service/ai/params_builder/builder.dart';
import 'package:vibcat/service/http.dart';
import 'package:vibcat/service/ai/volcano_engine_request.dart';

import 'openai_request.dart';

abstract class AIRequestService {
  ChatRequest get request;

  final httpClient = IHttpClient.create();

  AIRequestService();

  /// 工厂构造函数
  factory AIRequestService.create(ChatRequest request) =>
      switch (request.config.provider) {
        AIProviderType.openAI ||
        AIProviderType.deepseek ||
        AIProviderType.siliconFlow ||
        AIProviderType.groq ||
        AIProviderType.openRouter ||
        AIProviderType.ollama ||
        AIProviderType.bailian => OpenAIRequestService(request),
        AIProviderType.gemini => GeminiRequestService(request),
        AIProviderType.volcanoEngine => VolcanoEngineRequestService(request),
      };

  /// 获取指定服务商的 AI 模型列表
  Future<List<AIModel>> getModelList();

  /// 一次性返回，非流式
  Future<ChatResponse> chatCompletionsOnce();

  /// [模板方法] - 流式返回聊天结果。
  /// 此方法定义了流式请求的整体骨架，具体的解析逻辑由 parseStreamData 实现。
  Stream<ChatResponse> chatCompletions() async* {
    try {
      final reqBody = await ChatRequestParamsBuilder.build(request);

      final res = await httpClient.post(
        '${request.config.endPoint}/chat/completions',
        body: reqBody,
        headers: {'Authorization': 'Bearer ${request.config.apiKey}'},
        responseType: ResponseType.stream,
      );

      if (!res.isSuccess || res.data == null) {
        yield ChatResponse(type: ChatResponseType.error, content: res.message);
        return;
      }

      final stream = transformStream(res.raw);

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          if (kDebugMode) {
            print(line);
          }

          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') break;

          final Map<String, dynamic> data = jsonDecode(jsonStr);

          // 使用 yield* 将子类解析后的 stream 块融入当前 stream
          yield* parseStreamData(data);
        }
      }
    } catch (e) {
      yield ChatResponse(type: ChatResponseType.error, content: e.toString());
    }
  }

  /// [抽象方法] - 解析从流中获取的单个数据块。
  /// 子类需要实现此方法以处理特定于其服务的数据格式。
  @protected
  Stream<ChatResponse> parseStreamData(Map<String, dynamic> data);

  dynamic transformStream(Response<dynamic> response) {
    return response.data.stream
        // type 'Utf8Decoder' is not a subtype of type 'StreamTransformer<Uint8List, dynamic>' of 'streamTransformer'
        // or .map((chunk) => chunk.toList()) // Uint8List -> List<int>
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }
}
