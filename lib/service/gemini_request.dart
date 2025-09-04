import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/service/openai_request.dart';

import '../data/bean/ai_model.dart';
import '../data/schema/ai_model_config.dart';
import '../data/schema/chat_message.dart';
import '../data/schema/conversation.dart';
import '../enum/chat_message_type.dart';

class GeminiRequestService extends OpenAIRequestService {
  @override
  Stream<ChatMessage?> chatCompletions({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async* {
    try {
      final res = await dio.post(
        '${config.endPoint}/chat/completions',
        data: await buildReqParams(
          config: config,
          model: model,
          conversation: conversation,
          history: history,
        ),
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          responseType: ResponseType.stream,
        ),
      );

      final stream = transformStream(res);

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

          String? content = data['choices'][0]['delta']?['content'];

          if (content != null) {
            if (content.startsWith("<thought>")) {
              thinkFinished = false;
              content = content.replaceFirst('<thought>', '');
            }
            if (content.contains("</thought>")) {
              thinkFinished = true;
              content = content.replaceFirst('</thought>', '');
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
}
