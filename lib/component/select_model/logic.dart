import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/route/route.dart';

import 'state.dart';

class SelectModelLogic extends GetxController {
  final SelectModelState state = SelectModelState();

  final _repoDBApp = Get.find<AppDBRepository>();

  @override
  void onInit() async {
    super.onInit();

    state.aiModelConfigList.value = (await _repoDBApp.getAIModelConfigList())
        .where((item) => item.hasModels)
        .toList();
  }

  void selectModel(AIModelConfig item, AIModel model) {
    AppRoute.back(result: {'modelConfig': item, 'model': model});
  }
}
