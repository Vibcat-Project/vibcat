import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vibcat/bean/option_bottom_sheet.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/util/dialog.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  final listViewController = ScrollController();

  final _repoDBApp = Get.find<AppDBRepository>();
  final _repoNetAI = Get.find<AINetRepository>();

  @override
  void onInit() {
    super.onInit();

    listViewController.addListener(() {
      if (listViewController.offset > 0 && !state.showAppbarDivider.value) {
        state.showAppbarDivider.value = true;
      } else if (listViewController.offset <= 0 &&
          state.showAppbarDivider.value) {
        state.showAppbarDivider.value = false;
      }
    });
  }

  void getModelList() async {
    final aiModelConfig = (await _repoDBApp.getAIModelConfigList()).firstOrNull;
    if (aiModelConfig == null) {
      DialogUtil.showSnackBar("模型服务商为空");
      return;
    }
    final list = await _repoNetAI.getModelList(aiModelConfig);
    DialogUtil.showOptionBottomSheet(
      list.map((item) => OptionBottomSheetItem(item.id, 0)).toList(),
    );
  }

  @override
  void onClose() {
    listViewController.dispose();
    super.onClose();
  }
}
