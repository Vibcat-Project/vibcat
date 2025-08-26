import 'package:json_annotation/json_annotation.dart';

part 'ai_model.g.dart';

@JsonSerializable()
class AIModel {
  final String id;
  final String? object;
  final int? created;

  @JsonKey(name: 'owned_by')
  final String? ownedBy;

  AIModel({required this.id, this.object, this.created, this.ownedBy});

  factory AIModel.fromJson(Map<String, dynamic> json) =>
      _$AIModelFromJson(json);

  Map<String, dynamic> toJson() => _$AIModelToJson(this);
}

extension AIModelDeepCopy on AIModel {
  AIModel deepCopy() {
    return AIModel(id: id, object: object, created: created, ownedBy: ownedBy);
  }
}
