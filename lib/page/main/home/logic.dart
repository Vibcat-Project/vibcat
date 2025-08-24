import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vibcat/component/select_model/logic.dart';
import 'package:vibcat/component/select_model/view.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/util/app.dart';
import 'package:vibcat/util/dialog.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  final listViewController = ScrollController();
  final tePromptController = TextEditingController();

  // 为每个思考内容添加ScrollController的Map
  final Map<int, ScrollController> reasoningScrollControllers = {};

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

  /// 获取或创建 ScrollController
  ScrollController getReasoningScrollController(int index) {
    if (!reasoningScrollControllers.containsKey(index)) {
      reasoningScrollControllers[index] = ScrollController();
    }
    return reasoningScrollControllers[index]!;
  }

  void scrollReasoningToBottom(int index) {
    if (index < 0 || index >= state.chatMessage.length) return;

    final controller = getReasoningScrollController(index);
    if (controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animateTo(
          0.0, // reverse: true时，0.0是底部
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void selectModel() async {
    final hasAIModelProvider = (await _repoDBApp.getAIModelConfigList()).any(
      (e) => e.hasModels,
    );
    if (!hasAIModelProvider) {
      DialogUtil.showSnackBar("模型服务商为空");
      return;
    }

    final result = await BlurBottomSheet.show<SelectModelLogic>(
      'selectModels'.tr,
      SelectModelComponent(),
    );
    if (result is! Map) {
      return;
    }

    state.currentAIModelConfig.value = result['modelConfig'];
    state.currentAIModel.value = result['model'];
  }

  void chat() async {
    AppUtil.hideKeyboard();

    state.isResponding.value = true;

    final msg = ChatMessage()
      ..role = ChatRole.user
      ..content = tePromptController.text;

    final stream = _repoNetAI.completions(
      config: state.currentAIModelConfig.value!,
      model: state.currentAIModel.value!,
      history: [...state.chatMessage, msg],
    );

    state.chatMessage.add(msg);

    final responseMsg = ChatMessage()..role = ChatRole.assistant;
    state.chatMessage.add(responseMsg);

    tePromptController.clear();

    await for (final delta in stream) {
      if (delta == null) {
        return;
      }

      responseMsg.content = (responseMsg.content ?? '') + (delta.content ?? '');
      if (delta.reasoning != null) {
        responseMsg.reasoning =
            (responseMsg.reasoning ?? '') + delta.reasoning!;
        scrollReasoningToBottom(state.chatMessage.length - 1);
      }

      state.chatMessage.refresh();
    }

    state.isResponding.value = false;
  }

  @override
  void onClose() {
    // 清理ScrollController
    for (var controller in reasoningScrollControllers.values) {
      controller.dispose();
    }
    reasoningScrollControllers.clear();

    listViewController.dispose();
    tePromptController.dispose();

    super.onClose();
  }
}
