import 'package:get/get.dart';
import 'package:vibcat/component/add_model_provider/logic.dart';
import 'package:vibcat/component/add_model_provider/view.dart';
import 'package:vibcat/component/add_models/logic.dart';
import 'package:vibcat/component/add_models/view.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/enum/normal_dialog_button.dart';
import 'package:vibcat/util/dialog.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import '../../data/repository/database/app_db.dart';
import 'state.dart';

class ModelSettingsLogic extends GetxController {
  final ModelSettingsState state = ModelSettingsState();

  final _repoDBApp = Get.find<AppDBRepository>();

  @override
  void onInit() {
    super.onInit();

    _refresh();
  }

  void _refresh() async {
    state.aiModelConfigList.value = await _repoDBApp.getAIModelConfigList();
  }

  void showAddModelSheet() async {
    final result = await BlurBottomSheet.show<AddModelProviderLogic>(
      'addModelProvider'.tr,
      AddModelProviderComponent(),
      ignoreMaxHeight: true,
    );
    if (result is! AIModelConfig) {
      return;
    }

    state.aiModelConfigList.add(result);
  }

  void showModelList(int index) async {
    Get.put(AddModelsLogic(state.aiModelConfigList[index]));

    final result = await BlurBottomSheet.show<AddModelsLogic>(
      'selectModels'.tr,
      AddModelsComponent(),
      ignorePadding: true,
    );
    if (result != true) {
      return;
    }

    _refresh();
  }

  void edit(int index) {}

  void delete(int index) async {
    final ok = await DialogUtil.showNormalDialog(
      'sureToDeleteAIModelConfig'.tr,
    );
    if (ok != NormalDialogButton.ok) {
      return;
    }

    final success = await _repoDBApp.deleteAIModelConfig(
      state.aiModelConfigList[index],
    );
    if (success) {
      state.aiModelConfigList.removeAt(index);
    } else {
      //
    }
  }
}
