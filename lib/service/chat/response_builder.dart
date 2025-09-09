import 'package:vibcat/data/schema/chat_message.dart';

import '../../bean/chat_request.dart';
import 'chat_event.dart';

class ChatResponseBuilder {
  final StringBuffer _contentBuffer = StringBuffer();
  final StringBuffer _reasoningBuffer = StringBuffer();
  TokenUsage? _tokenUsage;
  String? _reasoningTime;

  ChatMessage get finalMessage => ChatMessage()
    ..content = _contentBuffer.toString()
    ..reasoning = _reasoningBuffer.toString()
    ..tokenInput = _tokenUsage?.input ?? 0
    ..tokenOutput = _tokenUsage?.output ?? 0
    ..reasoningTimeConsuming = _reasoningTime;

  ChatEvent build(ChatResponse response) {
    return switch (response.type) {
      ChatResponseType.content => _handleContent(response.content!),
      ChatResponseType.reasoning => _handleReasoning(response.reasoning!),
      ChatResponseType.usage => _handleUsage(response.tokenUsage),
      ChatResponseType.error => ChatEvent.error(response.content ?? ''),
    };
  }

  ChatEvent _handleContent(String content) {
    _contentBuffer.write(content);
    return ChatEvent.content(content);
  }

  ChatEvent _handleReasoning(String reasoning) {
    _reasoningBuffer.write(reasoning);
    return ChatEvent.reasoning(reasoning);
  }

  ChatEvent _handleUsage(TokenUsage usage) {
    _tokenUsage = usage;
    return ChatEvent.usage(usage);
  }
}
