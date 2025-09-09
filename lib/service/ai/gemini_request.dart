import 'package:vibcat/service/ai/openai_request.dart';

import '../../bean/chat_request.dart';

class GeminiRequestService extends OpenAIRequestService {
  bool _thinkFinished = true;

  GeminiRequestService(super.request);

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

    String? content = delta['content'];

    if (content != null) {
      if (content.startsWith("<thought>")) {
        _thinkFinished = false;
        content = content.replaceFirst('<thought>', '');
      }
      if (content.contains("</thought>")) {
        _thinkFinished = true;
        content = content.replaceFirst('</thought>', '');
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
}
