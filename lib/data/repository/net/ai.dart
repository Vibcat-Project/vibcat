import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/service/ai_request.dart';

import '../../schema/chat_message.dart';
import '../../schema/conversation.dart';

class AINetRepository {
  Future<List<AIModel>> getModelList(AIModelConfig config) async {
    return AIRequestService.create(
      config: config,
      model: AIModel(id: ''),
      conversation: Conversation(),
      history: [],
    ).getModelList();
  }

  Stream<ChatMessage?> chatCompletions({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) {
    return AIRequestService.create(
      config: config,
      model: model,
      conversation: conversation,
      history: history,
    ).chatCompletions();
  }

  Future<ChatMessage?> topicNaming({
    required AIModelConfig config,
    required AIModel model,
    required Conversation conversation,
    required List<ChatMessage> history,
  }) async {
    final result = await AIRequestService.create(
      config: config,
      model: model,
      conversation: conversation,
      history: history.map((e) {
        return ChatMessage()
          ..role = e.role
          ..content = e.content
          ..files = []; // 只清空副本的 files
      }).toList(),
    ).chatCompletionsOnce();
    if (result?.content?.isNotEmpty == true) {
      return result;
    }

    return null;
  }
}
