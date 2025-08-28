import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/service/ai_request.dart';

import '../data/schema/conversation.dart';

class OpenAIRequestService extends AIRequestService {
  @override
  Future<List<AIModel>> getModelList({required AIModelConfig config}) async {
    try {
      final res = await dio.get(
        '${config.endPoint}/models',
        options: Options(headers: {'Authorization': 'Bearer ${config.apiKey}'}),
      );
      if (res.statusCode != 200) {
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
  Stream<ChatMessage?> chatCompletions({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async* {
    try {
      final messages = history
          .map((item) => {'role': item.role.name, 'content': item.content})
          .toList();

      final res = await dio.post(
        '${config.endPoint}/chat/completions',
        data: {
          'model': model.id,
          'messages': messages,
          'stream': true,
          'stream_options': {'include_usage': true},
          // 'reasoning_effort': conversation.thinkType.name,
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
          // print(line);

          final jsonStr = line.substring(6).trim();
          if (jsonStr == '[DONE]') break;

          final Map<String, dynamic> data = jsonDecode(jsonStr);
          if (data['choices'].isEmpty) {
            continue;
          }

          final content = data['choices'][0]['delta']['content'];
          final reasoning = data['choices'][0]['delta']['reasoning_content'];

          // 针对 SiliconFlow
          if (reasoning != null) {
            yield ChatMessage()..reasoning = reasoning;
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
              yield ChatMessage()..content = content;
            } else {
              yield ChatMessage()..reasoning = content;
            }
          }
        }
      }
    } on DioException catch (e) {
      yield null;
    } catch (e) {
      yield null;
    }
  }

  @override
  Future<ChatMessage?> chatCompletionsOnce({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async {
    try {
      final messages = history
          .map((item) => {'role': item.role.name, 'content': item.content})
          .toList();

      final res = await dio.post(
        '${config.endPoint}/chat/completions',
        data: {'model': model.id, 'messages': messages, 'stream': false},
        options: Options(headers: {'Authorization': 'Bearer ${config.apiKey}'}),
      );
      if (res.statusCode != 200) {
        return null;
      }

      if (res.data['choices'].isEmpty) {
        return null;
      }

      final content = res.data['choices'][0]['message']['content'];
      return ChatMessage()..content = content;
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
