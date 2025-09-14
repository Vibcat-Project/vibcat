import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:vibcat/enum/tray_menu_item.dart';
import 'package:vibcat/global/images.dart';
import 'package:vibcat/global/isar.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/theme.dart';
import 'package:window_manager/window_manager.dart';

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

  await initTrayManager();
}

/// 初始化桌面系统托盘
Future<void> initTrayManager() async {
  if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) return;

  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  await windowManager.setPreventClose(true); // 拦截关闭事件

  await trayManager.setIcon(
    Platform.isWindows ? AppImage.logoFillRoundIco : AppImage.logoPng,
  );

  await trayManager.setContextMenu(
    Menu(
      items: [
        MenuItem(key: TrayMenuItem.show.name, label: '显示窗口'),
        MenuItem(key: TrayMenuItem.exit.name, label: '退出'),
      ],
    ),
  );
}
