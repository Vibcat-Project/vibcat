import 'package:vibcat/bean/chat_request.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/service/ai/ai_request.dart';

import '../../schema/chat_message.dart';
import '../../schema/conversation.dart';

class AINetRepository {
  Future<List<AIModel>> getModelList(AIModelConfig config) async {
    return AIRequestService.create(
      ChatRequest(
        config: config,
        model: AIModel(id: ''),
        conversation: Conversation(),
        messages: [],
      ),
    ).getModelList();
  }

  Stream<ChatResponse> chatCompletions(ChatRequest request) {
    return AIRequestService.create(request).chatCompletions();
  }

  Future<ChatResponse> chatCompletionOnce(ChatRequest request) async {
    return await AIRequestService.create(
      request.copyWith(
        messages: request.messages.map((e) {
          return ChatMessage()
            ..role = e.role
            ..content = e.content
            ..files = []; // 只清空副本的 files
        }).toList(),
      ),
    ).chatCompletionsOnce();
  }
}
