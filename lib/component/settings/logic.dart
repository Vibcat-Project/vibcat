import 'package:get/get.dart';

import '../../route/route.dart';
import 'state.dart';

class SettingsLogic extends GetxController {
  final SettingsState state = SettingsState();

  void onSettingsItemSelected(String title) {
    switch (title) {
      case 'modelSettings':
        AppRoute.toModelSettings();
        break;
      case 'onlineSearch':
        break;
      case 'chatSettings':
        break;
      case 'otherSettings':
        break;
      default:
    }
  }
}
