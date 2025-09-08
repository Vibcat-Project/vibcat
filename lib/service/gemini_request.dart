import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/service/openai_request.dart';

import '../data/schema/chat_message.dart';
import '../enum/chat_message_type.dart';

class GeminiRequestService extends OpenAIRequestService {
  GeminiRequestService({
    required super.config,
    required super.model,
    required super.conversation,
    required super.history,
    super.additionalParams,
  });

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
