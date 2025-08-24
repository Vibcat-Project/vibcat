import 'package:isar/isar.dart';
import 'package:vibcat/data/repository/database/base.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';

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

    for (final element in list) {
      element.loadAnyData();
    }

    return list;
  }

  /// 删除指定的模型服务商
  Future<bool> deleteAIModelConfig(AIModelConfig config) async {
    return await isar.writeTxn(() async {
      return await isar.aIModelConfigs.delete(config.id);
    });
  }

  /// 添加一条 ChatMessage 记录
  Future<int> insertChatMessage(ChatMessage msg) async {
    msg.prepareForSave();

    return await isar.writeTxn(() async {
      return await isar.chatMessages.put(msg);
    });
  }
}
