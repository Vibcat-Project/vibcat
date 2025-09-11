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
    // 设置 Android 状态栏为透明的沉浸
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
    // 忽略系统字体缩放
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: child!,
    ),
  );
}
