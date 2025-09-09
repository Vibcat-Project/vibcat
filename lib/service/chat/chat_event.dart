import 'package:vibcat/bean/chat_request.dart';

sealed class ChatEvent {
  const ChatEvent();

  factory ChatEvent.processing(String status, {String? desc}) = ProcessingEvent;

  factory ChatEvent.reasoning(String content) = ReasoningEvent;

  factory ChatEvent.content(String content) = ContentEvent;

  factory ChatEvent.usage(TokenUsage usage) = UsageEvent;

  factory ChatEvent.completed() = CompletedEvent;

  factory ChatEvent.error(String message) = ErrorEvent;
}

class ProcessingEvent extends ChatEvent {
  final String status;
  final String? desc;

  const ProcessingEvent(this.status, {this.desc});
}

class ReasoningEvent extends ChatEvent {
  final String content;

  const ReasoningEvent(this.content);
}

class ContentEvent extends ChatEvent {
  final String content;

  const ContentEvent(this.content);
}

class UsageEvent extends ChatEvent {
  final TokenUsage usage;

  const UsageEvent(this.usage);
}

class CompletedEvent extends ChatEvent {}

class ErrorEvent extends ChatEvent {
  final String message;

  const ErrorEvent(this.message);
}
