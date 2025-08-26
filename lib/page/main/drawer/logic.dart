import 'package:get/get.dart';
import 'package:vibcat/component/settings/logic.dart';
import 'package:vibcat/component/settings/view.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/page/main/home/logic.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import 'state.dart';

class DrawerLogic extends GetxController {
  final DrawerState state = DrawerState();

  final _repoDBApp = Get.find<AppDBRepository>();

  @override
  void onInit() {
    super.onInit();

    refreshList();
  }

  void refreshList({bool newConv = false, bool byAdd = false}) async {
    if (newConv) {
      state.currentIndex.value = -1;
    } else if (byAdd) {
      state.currentIndex.value = 0;
    }

    state.list.value = await _repoDBApp.getConversationList();
  }

  void deleteConversation(int index) async {
    final conversation = state.list[index];

    final success = await _repoDBApp.deleteConversation(conversation);
    if (!success) {
      return;
    }

    await _repoDBApp.deleteChatMessageByConversation(conversation);

    state.list.removeAt(index);
    // 更新当前索引
    if (index < state.currentIndex.value) {
      state.currentIndex.value -= 1;
    }

    // 通知 Home 继续处理逻辑
    Get.find<HomeLogic>().onDeleteConversation(conversation);
  }

  void showSettingsSheet() {
    BlurBottomSheet.show<SettingsLogic>('settings'.tr, SettingsComponent());
  }
}
