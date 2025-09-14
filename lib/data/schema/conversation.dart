import 'package:isar/isar.dart';
import 'package:vibcat/data/schema/base.dart';
import 'package:vibcat/enum/ai_think_type.dart';

part 'conversation.g.dart';

@collection
class Conversation extends BaseSchema {
  @Index()
  late int aiConfigId;

  late String modelId;

  late String title;

  @Enumerated(EnumType.name)
  AIThinkType thinkType = AIThinkType.auto;

  Conversation copyWith({
    int? aiConfigId,
    String? modelId,
    String? title,
    AIThinkType? thinkType,
  }) {
    return Conversation()
      ..aiConfigId = aiConfigId ?? this.aiConfigId
      ..modelId = modelId ?? this.modelId
      ..title = title ?? this.title
      ..thinkType = thinkType ?? this.thinkType;
  }
}
