import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vibcat/component/select_model/logic.dart';
import 'package:vibcat/component/select_model/view.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/ai_think_type.dart';
import 'package:vibcat/enum/chat_message_status.dart';
import 'package:vibcat/enum/chat_message_type.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/page/main/drawer/logic.dart';
import 'package:vibcat/util/app.dart';
import 'package:vibcat/util/dialog.dart';
import 'package:vibcat/util/haptic.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import 'state.dart';

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final HomeState state = HomeState();

  final listViewController = ScrollController();
  final reasoningController = ScrollController();
  final tePromptController = TextEditingController();

  final _repoDBApp = Get.find<AppDBRepository>();
  final _repoNetAI = Get.find<AINetRepository>();

  late AnimationController pulseController;

  @override
  void onInit() {
    super.onInit();

    pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    listViewController.addListener(() {
      if (listViewController.offset > 0 && !state.showAppbarDivider.value) {
        state.showAppbarDivider.value = true;
      } else if (listViewController.offset <= 0 &&
          state.showAppbarDivider.value) {
        state.showAppbarDivider.value = false;
      }
    });
  }

  /// 创建新对话
  void newConversation([bool temporary = false]) {
    state.isTemporaryChat.value = temporary;
    state.currentConversation.value = null;
    // state.currentAIModelConfig.value = null;
    // state.currentAIModel.value = null;
    state.chatMessage.clear();

    // 通知 DrawerLogic 继续处理逻辑
    Get.find<DrawerLogic>().refreshList(newConv: true);
  }

  void loadConversation(Conversation conversation) async {
    state.isTemporaryChat.value = false;
    state.currentConversation.value = conversation;
    state.currentAIModelConfig.value = await _repoDBApp.getAIModelConfig(
      conversation.aiConfigId,
    );
    state.currentAIModel.value = state.currentAIModelConfig.value?.models
        ?.firstWhereOrNull((e) => e.id == conversation.modelId);
    state.thinkType.value = conversation.thinkType;
    state.chatMessage.clear();
    state.chatMessage.addAll(await _repoDBApp.getChatMessageList(conversation));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listViewController.hasClients) {
        listViewController.jumpTo(listViewController.position.maxScrollExtent);
      }
    });
  }

  void onDeleteConversation(Conversation conversation) {
    if (conversation.id != state.currentConversation.value?.id) {
      return;
    }

    newConversation();
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

  void changeThinkType(AIThinkType type) async {
    // final result = await DialogUtil.showOptionBottomSheet(
    //   AIThinkType.values
    //       .map((e) => OptionBottomSheetItem(e.plainName.tr, e))
    //       .toList(),
    //   current: state.thinkType.value,
    // );
    // if (result == null) {
    //   return;
    // }

    state.thinkType.value = type;
  }

  void chat() async {
    if (state.isResponding.value) {
      return;
    }

    final prompt = tePromptController.text.trim();
    if (prompt.isEmpty) {
      return;
    }

    if (state.currentAIModel.value == null) {
      DialogUtil.showSnackBar('selectModelFirst'.tr);
      HapticUtil.error();
      return;
    }

    AppUtil.hideKeyboard();

    state.isResponding.value = true;

    var conv = state.currentConversation.value;

    if (conv == null) {
      // 新建对话
      conv = Conversation()
        ..title = prompt.substring(0, min(30, prompt.length))
        ..aiConfigId = state.currentAIModelConfig.value!.id
        ..modelId = state.currentAIModel.value!.id
        ..thinkType = state.thinkType.value;
    } else {
      conv
        ..aiConfigId = state.currentAIModelConfig.value!.id
        ..modelId = state.currentAIModel.value!.id
        ..thinkType = state.thinkType.value;
    }

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertConversation(conv);
    }
    state.currentConversation.value = conv;

    // 刷新历史记录列表
    Get.find<DrawerLogic>().refreshList(byAdd: true);

    final msg = ChatMessage()
      ..conversationId = conv.id
      ..role = ChatRole.user
      ..type = ChatMessageType.text
      ..content = prompt;

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertChatMessage(msg);
    }

    state.chatMessage.add(msg);

    HapticUtil.soft();

    final stream = _repoNetAI.completions(
      config: state.currentAIModelConfig.value!,
      model: state.currentAIModel.value!,
      conversation: conv,
      history: List.of(state.chatMessage), // 拷贝一份
    );

    final responseMsg = ChatMessage()
      ..conversationId = conv.id
      ..role = ChatRole.assistant
      ..type = ChatMessageType.text
      ..status = ChatMessageStatus.sending;

    state.chatMessage.add(responseMsg);

    tePromptController.clear();

    await for (final delta in stream) {
      if (delta == null) {
        state.isResponding.value = false;

        responseMsg.status = ChatMessageStatus.failed;
        state.chatMessage.refresh();

        HapticUtil.error();
        return;
      }

      responseMsg.status = ChatMessageStatus.streaming;
      responseMsg.content = (responseMsg.content ?? '') + (delta.content ?? '');
      if (delta.reasoning != null) {
        responseMsg.reasoning =
            (responseMsg.reasoning ?? '') + delta.reasoning!;
        scrollReasoningToBottom();
      }

      state.chatMessage.refresh();
    }

    responseMsg.status = ChatMessageStatus.success;
    state.chatMessage.refresh();

    state.isResponding.value = false;

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertChatMessage(responseMsg);
    }

    HapticUtil.success();
  }

  void scrollReasoningToBottom() {
    if (reasoningController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reasoningController.animateTo(
          0.0, // reverse: true 时，0.0 是底部
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void onClose() {
    reasoningController.dispose();
    listViewController.dispose();
    tePromptController.dispose();

    pulseController.dispose();

    super.onClose();
  }
}
