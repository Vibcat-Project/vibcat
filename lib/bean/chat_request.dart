import '../data/bean/ai_model.dart';
import '../data/schema/ai_model_config.dart';
import '../data/schema/chat_message.dart';
import '../data/schema/conversation.dart';

class ChatRequest {
  final AIModelConfig config;
  final AIModel model;
  final Conversation conversation;
  final List<ChatMessage> messages;
  final Map<String, Object>? additionalParams;

  const ChatRequest({
    required this.config,
    required this.model,
    required this.conversation,
    required this.messages,
    this.additionalParams,
  });

  ChatRequest copyWith({
    AIModelConfig? config,
    AIModel? model,
    Conversation? conversation,
    List<ChatMessage>? messages,
    Map<String, Object>? additionalParams,
    bool? stream,
  }) {
    return ChatRequest(
      config: config ?? this.config,
      model: model ?? this.model,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      additionalParams: additionalParams ?? this.additionalParams,
    );
  }
}

class ChatResponse {
  final ChatResponseType type;
  final String? content;
  final String? reasoning;
  final TokenUsage tokenUsage;

  bool get isSuccess =>
      type != ChatResponseType.error && content?.isNotEmpty == true;

  const ChatResponse({
    required this.type,
    this.content,
    this.reasoning,
    this.tokenUsage = const TokenUsage(input: 0, output: 0, reasoning: 0),
  });

  ChatResponse copyWith({
    ChatResponseType? type,
    String? content,
    String? reasoning,
    TokenUsage? tokenUsage,
  }) {
    return ChatResponse(
      type: type ?? this.type,
      content: content ?? this.content,
      reasoning: reasoning ?? this.reasoning,
      tokenUsage: tokenUsage ?? this.tokenUsage,
    );
  }
}

enum ChatResponseType { content, reasoning, usage, error }

class TokenUsage {
  final int input;
  final int output;
  final int reasoning;

  const TokenUsage({
    required this.input,
    required this.output,
    required this.reasoning,
  });
}
