import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/service/openai_request.dart';

import '../data/bean/ai_model.dart';
import '../data/schema/ai_model_config.dart';
import '../data/schema/chat_message.dart';
import '../data/schema/conversation.dart';
import '../enum/ai_think_type.dart';

class VolcanoEngineRequestService extends OpenAIRequestService {
  @override
  Future<List<AIModel>> getModelList({required AIModelConfig config}) async {
    // 暂时没找到 火山引擎 的获取模型列表的 API 接口，只能先预置一份了 👎
    final modelList = [
      "deepseek-v3-1-250821",
      "doubao-seed-1-6-vision-250815",
      "doubao-seed-1-6-250615",
      "doubao-seed-1-6-flash-250715",
      "doubao-seed-1-6-flash-250615",
      "doubao-seed-1-6-thinking-250715",
      "doubao-seed-1-6-thinking-250615",
      "doubao-1-5-thinking-pro-250415",
      "doubao-1-5-thinking-vision-pro-250428",
      "doubao-1-5-thinking-pro-m-250428",
      "doubao-1-5-vision-pro-250328",
      "deepseek-r1-250120",
      "doubao-1-5-ui-tars-250428",
      "doubao-1-5-vision-pro-32k-250115",
      "doubao-1-5-vision-lite-250315",
      "doubao-1-5-pro-32k-character-250715",
      "kimi-k2-250711",
      "deepseek-v3-250324",
      "doubao-1-5-pro-32k-250115",
      "doubao-1-5-pro-32k-character-250228",
      "doubao-1-5-pro-256k-250115",
      "doubao-1-5-lite-32k-250115",
      "doubao-pro-32k-241215",
      "doubao-pro-32k-browsing-240828",
      "doubao-pro-32k-character-241215",
      "doubao-lite-32k-240828",
      "doubao-lite-32k-240628",
      "doubao-seedance-1-0-pro-250528",
      "doubao-seedance-1-0-lite-t2v-250428",
      "doubao-seedance-1-0-lite-i2v-250428",
      "wan2-1-14b-t2v-250225",
      "wan2-1-14b-i2v-250225",
      "wan2-1-14b-flf2v-250417",
      "doubao-seedream-3-0-t2i-250415",
      "doubao-seededit-3-0-i2i-250628",
      "deepseek-r1-250528",
      "doubao-clasi-s2t-241215",
      "doubao-embedding-large-text-250515",
      "doubao-embedding-large-text-240915",
      "doubao-embedding-text-240715",
      "doubao-embedding-vision-250615",
      "doubao-embedding-vision-250328",
    ];

    return modelList.map((e) => AIModel(id: e)).toList();
  }

  @override
  Stream<ChatMessage?> chatCompletions({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async* {
    try {
      final thinkingType = conversation.thinkType == AIThinkType.none
          ? 'disabled'
          : (conversation.thinkType == AIThinkType.auto ? 'auto' : 'enabled');

      final res = await dio.post(
        '${config.endPoint}/chat/completions',
        data: {
          'model': model.id,
          'messages': await transformMessages(history),
          'stream': true,
          'stream_options': {'include_usage': true},
          "extra_body": {
            "thinking": {"type": thinkingType},
          },
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          responseType: ResponseType.stream,
        ),
      );

      final stream = transformStream(res);

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          print(line);

          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') break;

          final Map<String, dynamic> data = jsonDecode(jsonStr);
          if (data['choices'].isEmpty) {
            continue;
          }

          String? content = data['choices'][0]['delta']['content'];
          final reasoning = data['choices'][0]['delta']['reasoning_content'];

          if (reasoning != null) {
            yield ChatMessage()..reasoning = reasoning;
            continue;
          }

          if (content != null) {
            yield ChatMessage()..content = content;
          }
        }
      }
    } catch (e) {
      yield null;
    }
  }
}
