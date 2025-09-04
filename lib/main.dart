import 'package:flutter/material.dart';
import 'package:vibcat/global/isar.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/theme.dart';

import 'app.dart';

void main() async {
  // If you're running an application and need to access the binary messenger
  // before `runApp()` has been called (for example, during plugin initialization),
  // then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()` first.
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化一些服务
  await init();

  // 开始渲染主程序
  runApp(createApp());
}

Future<void> init() async {
  // 初始化主题
  final brightness = WidgetsBinding.instance.window.platformBrightness;
  if (brightness == Brightness.dark) {
    GlobalStore.theme = ThemeStyle.defaultThemeDark();
  } else {
    GlobalStore.theme = ThemeStyle.defaultThemeLight();
  }

  // 初始化 Isar 数据库
  await IsarInstance.init();
}
