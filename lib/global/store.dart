import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/data/repository/database/app_config_db.dart';
import 'package:vibcat/data/schema/app_config.dart';

import '../theme.dart';

class GlobalStore {
  // 当前主题
  static ThemeData theme = ThemeStyle.defaultThemeLight();

  static AppThemeExtension get themeExt =>
      theme.extension<AppThemeExtension>()!;

  static AppConfig? _configInstance;

  static AppConfig get config {
    _configInstance ??= Get.find<AppConfigDBRepository>().getAppConfigSync();
    return _configInstance!;
  }

  static Future<void> saveConfig(AppConfig config) async {
    await Get.find<AppConfigDBRepository>().saveAppConfig(config);
    // 不直接使用参数的值是因为该配置类中有特殊字段需要处理，下面的方式会自动处理
    _configInstance = await Get.find<AppConfigDBRepository>().getAppConfig();
  }
}
