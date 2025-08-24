import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:vibcat/data/schema/base.dart';
import 'package:vibcat/enum/chat_message_status.dart';
import 'package:vibcat/enum/chat_message_type.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/util/json.dart';

part 'chat_message.g.dart';

@collection
class ChatMessage extends BaseSchema {
  late int conversationId;

  @Enumerated(EnumType.name)
  late ChatRole role;
  @Enumerated(EnumType.name)
  late ChatMessageType type;

  String? content;
  String? reasoning;
  String? mediaUrl;

  @Enumerated(EnumType.name)
  late ChatMessageStatus status;

  // 存储 metadata 的 JSON 字符串
  @protected
  String? metadataJson;

  // runtime 层解析出的 metadata（不会存库）
  @ignore
  Map<String, dynamic>? metadata;

  /// 保存前：把 metadata 转成 JSON
  void prepareForSave() {
    metadataJson = metadata == null ? null : JsonUtil.mapToJson(metadata!);
  }

  /// 加载后：把 JSON 转回 Map
  void loadAnyData() {
    if (metadataJson != null) {
      metadata = JsonUtil.mapFromJson(metadataJson!);
    }
  }
}
