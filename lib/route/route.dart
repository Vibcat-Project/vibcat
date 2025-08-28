import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/page/model_settings/view.dart';
import 'package:vibcat/page/settings/chat/view.dart';
import 'package:vibcat/page/settings/other/view.dart';

import '../page/main/view.dart';

/// ----------------------------
/// 全局中间件
/// ----------------------------
class GlobalMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // 这里可以做统一的拦截
    // if (!AuthService.to.isLoggedIn && route != Routes.login) {
    //   return const RouteSettings(name: Routes.login);
    // }
    return super.redirect(route);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // 统一打印日志
    // debugPrint("进入页面: ${page?.name}");
    return super.onPageCalled(page);
  }
}

/// ----------------------------
/// 自定义 AppPage（封装默认属性）
/// ----------------------------
class AppPage extends GetPage {
  AppPage({
    required super.name,
    required super.page,
    super.binding,
    List<GetMiddleware>? middlewares,
    Transition? transition,
  }) : super(
         middlewares: [GlobalMiddleware(), ...?middlewares],
         // 统一设置手势返回范围
         // gestureWidth: (_) => Get.width,
         // transitionDuration: Duration(milliseconds: 600),
       );
}

/// ----------------------------
/// 路由表
/// ----------------------------
class AppRoute {
  static const main = '/main';
  static const modelSettings = '/modelSettings';
  static const chatSettings = '/chatSettings';
  static const otherSettings = '/otherSettings';

  static final List<GetPage> routes = [
    AppPage(name: main, page: () => MainPage()),
    AppPage(name: modelSettings, page: () => ModelSettingsPage()),
    AppPage(name: chatSettings, page: () => ChatSettingsPage()),
    AppPage(name: otherSettings, page: () => OtherSettingsPage()),
  ];

  static dynamic get args => Get.arguments;

  static void back<T>({T? result}) {
    Get.back(result: result);
  }

  static void to(String name, {dynamic args, Transition? trans}) {
    if (trans == null) {
      Get.toNamed(name, arguments: args);
      return;
    }

    Get.to(
      routes.firstWhere((e) => e.name == name).page,
      arguments: args,
      transition: trans,
    );
  }

  static void toModelSettings() {
    to(modelSettings);
  }

  static void toChatSettings() {
    to(chatSettings);
  }

  static void toOtherSettings() {
    to(otherSettings);
  }

  // static void toNovelReader(Detail detail, int index) {
  //   to(novelReader, args: {'detail': detail, 'index': index});
  // }
}
