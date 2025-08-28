// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:vibcat/data/schema/app_config.dart';

import '../../schema/ai_model_config.dart';
import 'app_db.dart';
import 'base.dart';

class AppConfigDBRepository extends BaseDBRepository {
  /// 保存 App 配置信息
  Future<int> saveAppConfig(AppConfig config) async {
    config.prepareForSave();

    return await isar.writeTxn(() async {
      return await isar.appConfigs.put(config);
    });
  }

  /// 获取 App 配置信息
  Future<AppConfig> getAppConfig() async {
    final result = await isar.appConfigs.get(AppConfig.key);

    if (result != null) {
      final Future<AIModelConfig?> Function(int id) getAIModelConfig =
          Get.find<AppDBRepository>().getAIModelConfig;

      result.loadAnyData(
        result.topicNamingAIProviderId != null
            ? await getAIModelConfig(result.topicNamingAIProviderId!)
            : null,
        result.defaultConvAIProviderId != null
            ? await getAIModelConfig(result.defaultConvAIProviderId!)
            : null,
      );
    }

    return result ?? AppConfig();
  }

  /// 获取 App 配置信息
  AppConfig getAppConfigSync() {
    final result = isar.appConfigs.getSync(AppConfig.key);

    if (result != null) {
      final AIModelConfig? Function(int id) getAIModelConfigSync =
          Get.find<AppDBRepository>().getAIModelConfigSync;

      result.loadAnyData(
        result.topicNamingAIProviderId != null
            ? getAIModelConfigSync(result.topicNamingAIProviderId!)
            : null,
        result.defaultConvAIProviderId != null
            ? getAIModelConfigSync(result.defaultConvAIProviderId!)
            : null,
      );
    }

    return result ?? AppConfig();
  }
}
