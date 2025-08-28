import 'package:get/get.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/util/haptic.dart';

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
        AppRoute.toChatSettings();
        break;
      case 'otherSettings':
        AppRoute.toOtherSettings();
        break;
      default:
    }
  }

  void onHapticFeedbackChanged(bool value) async {
    await GlobalStore.saveConfig(GlobalStore.config..hapticFeedback = value);

    state.hapticFeedbackEnabled.value = value;
    if (value) {
      HapticUtil.normal();
    }
  }
}
