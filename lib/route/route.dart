import 'package:get/get.dart';
import 'package:vibcat/page/model_settings/view.dart';

import '../page/main/view.dart';

class AppRoute {
  static const main = '/main';
  static const modelSettings = '/modelSettings';

  static final List<GetPage> routes = [
    GetPage(name: main, page: () => MainPage()),
    GetPage(name: modelSettings, page: () => ModelSettingsPage()),
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

  // static void toNovelReader(Detail detail, int index) {
  //   to(novelReader, args: {'detail': detail, 'index': index});
  // }
}
