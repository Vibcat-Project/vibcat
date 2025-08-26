import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/route/route.dart';

import '../../data/repository/net/ai.dart';
import 'state.dart';

class AddModelsLogic extends GetxController with StateMixin<void> {
  final AIModelConfig aiModelConfig;

  AddModelsLogic(AIModelConfig aiModelConfig)
    : aiModelConfig = aiModelConfig.deepCopy();

  @override
  final AddModelsState state = AddModelsState();

  final _repoNetAI = Get.find<AINetRepository>();
  final _repoDBApp = Get.find<AppDBRepository>();

  final loadingKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = loadingKey.currentContext?.findRenderObject() as RenderBox?;
      state.height.value = box?.size.height ?? 0;
    });

    state.selectedModelList.value = aiModelConfig.models ?? [];

    _refresh();
  }

  void _refresh() async {
    state.modelList.value = await _repoNetAI.getModelList(aiModelConfig);

    change(null, status: RxStatus.success());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.height.value = Get.height * 0.5;
    });
  }

  void select(AIModel item, bool checked) {
    if (checked) {
      state.selectedModelList.removeWhere((e) => item.id == e.id);
    } else {
      state.selectedModelList.add(item);
    }

    update();
  }

  void save() async {
    await _repoDBApp.upsertAIModelConfig(
      aiModelConfig..models = state.selectedModelList,
    );

    AppRoute.back(result: true);
  }
}
