import 'package:vibcat/service/ai/openai_request.dart';

import '../../bean/chat_request.dart';
import '../../data/bean/ai_model.dart';

class VolcanoEngineRequestService extends OpenAIRequestService {
  VolcanoEngineRequestService(super.request);

  @override
  Future<List<AIModel>> getModelList() async {
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
      yield ChatResponse(type: ChatResponseType.reasoning, reasoning: content);
    }

    if (content != null) {
      yield ChatResponse(type: ChatResponseType.content, content: content);
    }
  }
}
