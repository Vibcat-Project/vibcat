import '../../data/schema/chat_message.dart';

sealed class ChatEvent {
  const ChatEvent();

  factory ChatEvent.processing(String status, {String? desc}) = ProcessingEvent;

  factory ChatEvent.aiResponding() = AIRespondingEvent;

  factory ChatEvent.reasoning(String content) = ReasoningEvent;

  factory ChatEvent.content(String content) = ContentEvent;

  factory ChatEvent.completed(ChatMessage message) = CompletedEvent;

  factory ChatEvent.error(String message) = ErrorEvent;
}

class ProcessingEvent extends ChatEvent {
  final String status;
  final String? desc;

  const ProcessingEvent(this.status, {this.desc});
}

class AIRespondingEvent extends ChatEvent {
  const AIRespondingEvent();
}

class ReasoningEvent extends ChatEvent {
  final String content;

  const ReasoningEvent(this.content);
}

class ContentEvent extends ChatEvent {
  final String content;

  const ContentEvent(this.content);
}

class CompletedEvent extends ChatEvent {
  final ChatMessage message;

  const CompletedEvent(this.message);
}

class ErrorEvent extends ChatEvent {
  final String message;

  const ErrorEvent(this.message);
}
