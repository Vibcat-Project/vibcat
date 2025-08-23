// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIModel _$AIModelFromJson(Map<String, dynamic> json) => AIModel(
      id: json['id'] as String,
      object: json['object'] as String,
      created: (json['created'] as num?)?.toInt(),
      ownedBy: json['owned_by'] as String,
    );

Map<String, dynamic> _$AIModelToJson(AIModel instance) => <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'owned_by': instance.ownedBy,
    };
