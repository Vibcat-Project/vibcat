import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/repository/database/app_db.dart';
import '../../data/schema/ai_model_config.dart';
import '../../route/route.dart';
import 'state.dart';

class AddModelLogic extends GetxController {
  final AddModelState state = AddModelState();

  final _repoDBApp = Get.find<AppDBRepository>();

  final pageController = PageController(initialPage: 0);

  late final teAPIEndPointController = TextEditingController(
    text: state.currentAIProvider.value.endPoint,
  );
  final teAPIKeyController = TextEditingController();
  late final teCustomNameController = TextEditingController(
    text: state.currentAIProvider.value.plainName,
  );

  void save() {
    final apiEndPoint = teAPIEndPointController.text.trim();
    final apiKey = teAPIKeyController.text.trim();
    final customName = teCustomNameController.text.trim();

    if (state.currentAIProvider.value.customEndPoint == true &&
        apiEndPoint.isEmpty) {
      state.showErrorAPIEndPointText.value = true;
      return;
    } else {
      state.showErrorAPIEndPointText.value = false;
    }
    if (apiKey.isEmpty) {
      state.showErrorAPIKeyText.value = true;
      return;
    } else {
      state.showErrorAPIKeyText.value = false;
    }
    if (customName.isEmpty) {
      state.showErrorCustomNameText.value = true;
      return;
    } else {
      state.showErrorCustomNameText.value = false;
    }

    // 保存数据
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final aiModelConfig = AIModelConfig(
        provider: state.currentAIProvider.value,
        endPoint: apiEndPoint,
        apiKey: apiKey,
        customName: customName,
      );

      await _repoDBApp.insertAIModelConfig(aiModelConfig);
      AppRoute.back(result: aiModelConfig);
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    teAPIEndPointController.dispose();
    teAPIKeyController.dispose();
    teCustomNameController.dispose();
    super.onClose();
  }
}
