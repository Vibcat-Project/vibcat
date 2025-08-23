import 'package:get/get.dart';
import 'package:vibcat/component/settings/logic.dart';
import 'package:vibcat/component/settings/view.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import 'state.dart';

class DrawerLogic extends GetxController {
  final DrawerState state = DrawerState();

  void showSettingsSheet() {
    BlurBottomSheet.show<SettingsLogic>('settings'.tr, SettingsComponent());
  }
}
