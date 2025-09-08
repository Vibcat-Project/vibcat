import 'package:json_annotation/json_annotation.dart';

part 'questions.g.dart';

@JsonSerializable(explicitToJson: true)
class Questions {
  final List<Question> questions;

  const Questions({required this.questions});

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}

@JsonSerializable()
class Question {
  final QuestionType type;
  final String query;
  final List<String> links;

  const Question({
    required this.type,
    required this.query,
    this.links = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum QuestionType {
  @JsonValue('websearch')
  webSearch,
  summarize,
  @JsonValue('not_needed')
  notNeeded,
}
