import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vibcat/route/binding.dart';
import 'package:vibcat/route/route.dart';
import 'package:vibcat/translation.dart';

import 'global/color.dart';
import 'global/store.dart';

Widget createApp() {
  if (Platform.isAndroid) {
    // 以下两行设置 android 状态栏为透明的沉浸。写在组件渲染 runApp() 之后
    // 是为了在渲染后进行 set 赋值，覆盖状态栏，写在渲染之前 MaterialApp 组件会覆盖掉这个值
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: AppColor.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColor.transparent,
      systemNavigationBarDividerColor: AppColor.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  return GetMaterialApp(
    title: 'Vibcat',
    debugShowCheckedModeBanner: false,
    translations: Translation(),
    locale: ui.window.locale,
    fallbackLocale: const Locale('zh', 'CN'),
    theme: GlobalStore.theme,
    initialBinding: AppBinding(),
    initialRoute: AppRoute.main,
    getPages: AppRoute.routes,
    defaultTransition: Transition.cupertino,
  );
}
