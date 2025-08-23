import 'package:isar/isar.dart';
import 'package:vibcat/data/repository/database/base.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';

class AppDBRepository extends BaseDBRepository {
  /// 添加一个模型服务商
  Future<int> insertAIModelConfig(AIModelConfig config) async {
    return await isar.writeTxn(() async {
      return await isar.aIModelConfigs.put(config);
    });
  }

  /// 获取所有已添加的模型服务商
  Future<List<AIModelConfig>> getAIModelConfigList() async {
    return await isar.aIModelConfigs.where().findAll();
  }

  /// 删除指定的模型服务商
  Future<bool> deleteAIModelConfig(AIModelConfig config) async {
    return await isar.writeTxn(() async {
      return await isar.aIModelConfigs.delete(config.id);
    });
  }
}
