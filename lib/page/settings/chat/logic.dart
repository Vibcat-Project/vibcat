import 'package:get/get.dart';
import 'package:vibcat/global/store.dart';

import '../../../component/select_model/logic.dart';
import '../../../component/select_model/view.dart';
import '../../../widget/blur_bottom_sheet.dart';
import 'state.dart';

class ChatSettingsLogic extends GetxController {
  final ChatSettingsState state = ChatSettingsState();

  /// 选择模型
  Future<void> selectModel(int type) async {
    final result = await BlurBottomSheet.show<SelectModelLogic>(
      'selectModels'.tr,
      SelectModelComponent(),
    );

    if (result is! Map) return;

    switch (type) {
      // 话题命名模型
      case 0:
        await GlobalStore.saveConfig(
          GlobalStore.config
            ..topicNamingAIProvider = result['modelConfig']
            ..topicNamingAIProviderModelId = result['model'].id,
        );
        break;
      // 默认对话模型
      case 1:
        await GlobalStore.saveConfig(
          GlobalStore.config
            ..defaultConvAIProvider = result['modelConfig']
            ..defaultConvAIProviderModelId = result['model'].id,
        );
        break;
      default:
        return;
    }

    update();
  }

  void onNewConvUseLastModelChanged(bool newState) async {
    await GlobalStore.saveConfig(
      GlobalStore.config..newConvUseLastModel = newState,
    );

    state.newConvUseLastModel.value = newState;
    update();
  }
}
