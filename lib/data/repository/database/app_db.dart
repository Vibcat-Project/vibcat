import 'package:isar/isar.dart';
import 'package:vibcat/data/repository/database/base.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';

class AppDBRepository extends BaseDBRepository {
  /// 添加或更新一个模型服务商
  Future<int> upsertAIModelConfig(AIModelConfig config) async {
    config.prepareForSave();

    return await isar.writeTxn(() async {
      return await isar.aIModelConfigs.put(config);
    });
  }

  /// 获取所有已添加的模型服务商
  Future<List<AIModelConfig>> getAIModelConfigList() async {
    final list = await isar.aIModelConfigs.where().findAll();

    for (final value in list) {
      value.loadAnyData();
    }

    return list;
  }

  /// 获取指定的模型服务商
  Future<AIModelConfig?> getAIModelConfig(int id) async {
    final item = await isar.aIModelConfigs.where().idEqualTo(id).findFirst();

    item?.loadAnyData();

    return item;
  }

  /// 删除指定的模型服务商
  Future<bool> deleteAIModelConfig(AIModelConfig config) async {
    return await isar.writeTxn(() async {
      return await isar.aIModelConfigs.delete(config.id);
    });
  }

  /// 添加或更新一个对话
  Future<int> upsertConversation(Conversation conversation) async {
    return await isar.writeTxn(() async {
      return await isar.conversations.put(conversation);
    });
  }

  /// 获取所有历史对话
  Future<List<Conversation>> getConversationList() async {
    return await isar.conversations.where().sortByUpdatedAtDesc().findAll();
  }

  /// 删除指定的历史对话
  Future<bool> deleteConversation(Conversation conversation) async {
    return await isar.writeTxn(() async {
      return await isar.conversations.delete(conversation.id);
    });
  }

  /// 添加一条 ChatMessage 记录
  Future<int> upsertChatMessage(ChatMessage msg) async {
    msg.prepareForSave();

    return await isar.writeTxn(() async {
      return await isar.chatMessages.put(msg);
    });
  }

  /// 获取指定 Conversation 的全部对话消息
  Future<List<ChatMessage>> getChatMessageList(
    Conversation conversation,
  ) async {
    final list = await isar.chatMessages
        .where()
        .conversationIdEqualTo(conversation.id)
        .findAll();

    for (final value in list) {
      value.loadAnyData();
    }

    return list;
  }

  /// 删除指定的历史对话的所有 ChatMessage
  Future<int> deleteChatMessageByConversation(Conversation conversation) async {
    return await isar.writeTxn(() async {
      return await isar.chatMessages
          .where()
          .conversationIdEqualTo(conversation.id)
          .deleteAll();
    });
  }
}
