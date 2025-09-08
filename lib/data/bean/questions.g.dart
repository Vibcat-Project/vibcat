// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questions _$QuestionsFromJson(Map<String, dynamic> json) => Questions(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionsToJson(Questions instance) => <String, dynamic>{
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      query: json['query'] as String,
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'query': instance.query,
      'links': instance.links,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.webSearch: 'websearch',
  QuestionType.summarize: 'summarize',
  QuestionType.notNeeded: 'not_needed',
};
