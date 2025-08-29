import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/enum/ai_think_type.dart';
import 'package:vibcat/service/openai_request.dart';

import '../data/bean/ai_model.dart';
import '../data/schema/ai_model_config.dart';
import '../data/schema/chat_message.dart';
import '../data/schema/conversation.dart';

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
        data: {
          'model': model.id,
          'messages': await transformMessages(history),
          'stream': true,
          'stream_options': {'include_usage': true},
          "extra_body": {
            "google": {
              "thinking_config": {
                "include_thoughts": conversation.thinkType != AIThinkType.none,
              },
            },
          },
        },
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
          String? content = data['choices'][0]['delta']['content'];

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
              yield ChatMessage()..content = content;
            } else {
              yield ChatMessage()..reasoning = content;
            }
          }
        }
      }
    } catch (e) {
      yield null;
    }
  }
}
