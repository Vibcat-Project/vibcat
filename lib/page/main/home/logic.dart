import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibcat/bean/upload_file.dart';
import 'package:vibcat/bean/web_search_args.dart';
import 'package:vibcat/component/select_model/logic.dart';
import 'package:vibcat/component/select_model/view.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/repository/net/web_search.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/add_options_type.dart';
import 'package:vibcat/enum/ai_think_type.dart';
import 'package:vibcat/enum/chat_message_status.dart';
import 'package:vibcat/enum/chat_message_type.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/global/prompts.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/page/main/drawer/logic.dart';
import 'package:vibcat/util/app.dart';
import 'package:vibcat/util/dialog.dart';
import 'package:vibcat/util/file_picker.dart';
import 'package:vibcat/util/haptic.dart';
import 'package:vibcat/util/number.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import '../../../widget/ripple_effect.dart';
import 'state.dart';

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final HomeState state = HomeState();

  final listViewController = ScrollController();
  final reasoningController = ScrollController();
  final tePromptController = TextEditingController();
  late AnimationController pulseController;

  final _repoDBApp = Get.find<AppDBRepository>();
  final _repoNetAI = Get.find<AINetRepository>();
  final _repoWebSearch = Get.find<WebSearchRepository>();

  // fontSize * lineHeight
  final double reasoningTextHeight = 14 * 1.4;

  // GlobalKey 用于获取最后一个消息 widget 的高度
  final lastUserMsgKey = GlobalKey();
  final lastAIMsgKey = GlobalKey();
  final rippleKey = GlobalKey<RippleEffectState>();

  bool _currentReasoningScrollFinished = true;
  DateTime? _reasoningStartTime;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _setupScrollListeners();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// 初始化动画
  void _initializeAnimations() {
    pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  /// 设置滚动监听
  void _setupScrollListeners() {
    listViewController.addListener(_onListViewScroll);
  }

  /// 列表滚动监听
  void _onListViewScroll() {
    final shouldShowDivider = listViewController.offset > 0;
    if (shouldShowDivider != state.showAppbarDivider.value) {
      state.showAppbarDivider.value = shouldShowDivider;
    }
  }

  /// 销毁控制器
  void _disposeControllers() {
    reasoningController.dispose();
    listViewController.dispose();
    tePromptController.dispose();
    pulseController.dispose();
  }

  /// 创建新对话
  void newConversation([bool temporary = false]) {
    state
      ..isTemporaryChat.value = temporary
      ..currentConversation.value = null
      ..chatMessage.clear()
      ..listBottomPadding.value = 0
      ..showAppbarDivider.value = false;
    // state.currentAIModelConfig.value = null;
    // state.currentAIModel.value = null;

    // 根据配置决定新对话模型选择
    if (!GlobalStore.config.newConvUseLastModel &&
        GlobalStore.config.isValidDefaultConvModel) {
      state
        ..currentAIModelConfig.value = GlobalStore.config.defaultConvAIProvider!
        ..currentAIModel.value = AIModel(
          id: GlobalStore.config.defaultConvAIProviderModelId!,
        );
    }

    // 通知 DrawerLogic 继续处理逻辑
    Get.find<DrawerLogic>().refreshList(newConv: true);
  }

  /// 加载对话
  Future<void> loadConversation(Conversation conversation) async {
    state
      ..isTemporaryChat.value = false
      ..currentConversation.value = conversation
      ..listBottomPadding.value = 0;

    // 加载 AI 模型配置
    await _loadConversationModel(conversation);

    // 加载聊天消息
    await _loadChatMessages(conversation);

    // 滚动到底部
    _scrollToBottom(false);
  }

  /// 加载对话的 AI 模型配置
  Future<void> _loadConversationModel(Conversation conversation) async {
    // TODO: 这里可能需要遵循默认模型配置策略
    state
      ..currentAIModelConfig.value = await _repoDBApp.getAIModelConfig(
        conversation.aiConfigId,
      )
      ..currentAIModel.value = state.currentAIModelConfig.value?.models
          ?.firstWhereOrNull((e) => e.id == conversation.modelId)
      ..thinkType.value = conversation.thinkType;
  }

  /// 加载聊天消息
  Future<void> _loadChatMessages(Conversation conversation) async {
    state.chatMessage
      ..clear()
      ..addAll(await _repoDBApp.getChatMessageList(conversation));
  }

  /// 滚动到底部
  void _scrollToBottom([bool anim = true]) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (anim) {
        listViewController.animateTo(
          listViewController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      } else {
        if (listViewController.hasClients) {
          listViewController.jumpTo(
            listViewController.position.maxScrollExtent,
          );
        }
      }
    });
  }

  /// 删除对话时的处理
  void onDeleteConversation(Conversation conversation) {
    if (conversation.id == state.currentConversation.value?.id) {
      newConversation();
    }
  }

  /// 选择模型
  Future<void> selectModel() async {
    if (!await _hasAIModelProvider()) {
      DialogUtil.showSnackBar('addModelProviderFirst'.tr);
      return;
    }

    final result = await _showModelSelection();
    if (result is Map) {
      _updateSelectedModel(result);
    }
  }

  /// 检查是否有 AI 模型提供商
  Future<bool> _hasAIModelProvider() async {
    final configs = await _repoDBApp.getAIModelConfigList();
    return configs.any((e) => e.hasModels);
  }

  /// 显示模型选择界面
  Future<dynamic> _showModelSelection() async {
    return await BlurBottomSheet.show<SelectModelLogic>(
      'selectModels'.tr,
      SelectModelComponent(),
    );
  }

  /// 更新选中的模型
  void _updateSelectedModel(Map result) {
    state
      ..currentAIModelConfig.value = result['modelConfig']
      ..currentAIModel.value = result['model'];
  }

  /// 改变思考类型
  void changeThinkType(AIThinkType type) {
    state.thinkType.value = type;
  }

  /// 主要的聊天函数
  Future<void> chat([bool retry = false]) async {
    if (state.isResponding.value) return;

    String prompt;
    if (retry) {
      // 重试时，获取最后一个用户消息
      prompt = _getLastUserMessage();
      if (prompt.isEmpty) return;

      // 移除最后的失败消息（如果存在）
      await _removeFailedMessage();
    } else {
      // 正常发送时，从输入框获取内容
      prompt = tePromptController.text.trim();
      if (prompt.isEmpty) return;
    }

    if (!await _validateChatConditions()) return;

    await _performChat(prompt, retry);
  }

  /// 获取最后一个用户消息
  String _getLastUserMessage() {
    final userMessages = state.chatMessage
        .where((msg) => msg.role == ChatRole.user)
        .toList();
    return userMessages.isNotEmpty ? userMessages.last.content ?? '' : '';
  }

  /// 移除失败的消息
  Future<void> _removeFailedMessage() async {
    if (state.chatMessage.isNotEmpty &&
        state.chatMessage.last.status == ChatMessageStatus.failed) {
      // 数据库的也要移除
      await _repoDBApp.deleteChatMessage(state.chatMessage.last);

      state.chatMessage.removeLast();
    }
  }

  /// 验证聊天条件
  Future<bool> _validateChatConditions() async {
    if (state.currentAIModel.value == null) {
      DialogUtil.showSnackBar('selectModelFirst'.tr);
      HapticUtil.error();
      return false;
    }
    return true;
  }

  /// 执行聊天
  Future<void> _performChat(String prompt, bool retry) async {
    AppUtil.hideKeyboard();
    state.isResponding.value = true;

    try {
      // 准备或创建对话
      final conv = await _prepareConversation(prompt);

      // 添加用户消息（非重试时）
      if (!retry) {
        final userMsg = await _addUserMessage(conv, prompt);
        tePromptController.clear();

        // 在线搜索
        for (final item in userMsg.files.whereType<UploadLink>()) {
          final result = await _repoWebSearch.request(
            HeadlessBrowserWebSearchArgs(url: item.name),
          );
          item.file = File(result ?? ' ');
          state.chatMessage.refresh();
        }

        if (!state.isTemporaryChat.value) {
          await _repoDBApp.upsertChatMessage(userMsg);
        }
      }

      // 发送请求并处理响应
      await _handleChatResponse(conv);
    } catch (e) {
      // 处理异常。这里目前不会走，因为 try 块中的代码不会抛异常
      _handleChatError();
    } finally {
      state.isResponding.value = false;
    }
  }

  /// 准备或创建对话
  Future<Conversation> _prepareConversation(String prompt) async {
    var conv = state.currentConversation.value;

    if (conv == null) {
      // 创建新对话
      conv = _createNewConversation(prompt);
    } else {
      // 更新现有对话的模型配置
      _updateConversationConfig(conv);
    }

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertConversation(conv);
      // 刷新历史记录列表
      Get.find<DrawerLogic>().refreshList(byAdd: true);
    }

    state.currentConversation.value = conv;

    return conv;
  }

  /// 创建新对话
  Conversation _createNewConversation(String prompt) {
    return Conversation()
      ..title = prompt.substring(0, min(30, prompt.length))
      ..aiConfigId = state.currentAIModelConfig.value!.id
      ..modelId = state.currentAIModel.value!.id
      ..thinkType = state.thinkType.value;
  }

  /// 更新对话配置
  void _updateConversationConfig(Conversation conv) {
    conv
      ..aiConfigId = state.currentAIModelConfig.value!.id
      ..modelId = state.currentAIModel.value!.id
      ..thinkType = state.thinkType.value;
  }

  /// 添加用户消息
  Future<ChatMessage> _addUserMessage(Conversation conv, String prompt) async {
    final msg = ChatMessage()
      ..conversationId = conv.id
      ..role = ChatRole.user
      ..type = ChatMessageType.text
      ..content = prompt
      ..files = List.of(state.selectedFiles);
    // ..files = state.selectedFiles.map((e) => e.deepCopy()).toList();

    // if (!state.isTemporaryChat.value) {
    //   await _repoDBApp.upsertChatMessage(msg);
    // }

    state
      ..selectedFiles.clear()
      ..chatMessage.add(msg);

    HapticUtil.soft();

    await AppUtil.waitKeyboardClosed();
    _adjustPaddingAndScroll(isStreaming: false);

    return msg;
  }

  /// 处理聊天响应
  Future<void> _handleChatResponse(Conversation conv) async {
    // 获取AI响应流
    final stream = _repoNetAI.chatCompletions(
      config: state.currentAIModelConfig.value!,
      model: state.currentAIModel.value!,
      conversation: conv,
      history: List.of(state.chatMessage),
    );

    // 创建响应消息
    final responseMsg = _createResponseMessage(conv);
    state.chatMessage.add(responseMsg);
    // await _adjustPaddingAndScroll(isStreaming: true);

    // 处理流式响应
    await _processResponseStream(stream, responseMsg);
  }

  /// 创建响应消息
  ChatMessage _createResponseMessage(Conversation conv) {
    return ChatMessage()
      ..conversationId = conv.id
      ..role = ChatRole.assistant
      ..type = ChatMessageType.text
      ..status = ChatMessageStatus.sending;
  }

  /// 处理响应流
  Future<void> _processResponseStream(
    Stream<dynamic> stream,
    ChatMessage responseMsg,
  ) async {
    await for (final delta in stream) {
      if (delta == null) {
        await _handleStreamError(responseMsg);
        return;
      }

      await _updateResponseMessage(delta, responseMsg);
    }

    await _finalizeResponse(responseMsg);
  }

  /// 处理流错误
  Future<void> _handleStreamError(ChatMessage responseMsg) async {
    responseMsg.status = ChatMessageStatus.failed;
    state.chatMessage.refresh();

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertChatMessage(responseMsg);
    }

    HapticUtil.error();
  }

  /// 更新响应消息
  Future<void> _updateResponseMessage(
    ChatMessage delta,
    ChatMessage responseMsg,
  ) async {
    final currentStatus = responseMsg.status;

    responseMsg
      ..status = ChatMessageStatus.streaming
      ..content = (responseMsg.content ?? '') + (delta.content ?? '');

    if (delta.type == ChatMessageType.usage) {
      responseMsg
        ..tokenInput = delta.tokenInput
        ..tokenOutput = delta.tokenOutput
        ..tokenReasoning = delta.tokenReasoning;
      return;
    }

    if (delta.reasoning != null) {
      // 思考中
      _reasoningStartTime ??= DateTime.now();

      responseMsg
        ..reasoning = (responseMsg.reasoning ?? '') + delta.reasoning!
        ..status = ChatMessageStatus.reasoning;

      scrollReasoningToBottom();
    } else {
      // 思考完毕
      if (_reasoningStartTime != null) {
        responseMsg.reasoningTimeConsuming =
            '${DateTime.now().difference(_reasoningStartTime!).inSeconds}s';
        _reasoningStartTime = null;
      }
    }

    // 切换状态的情况下，先重更新一下 padding，避免由于 padding 值的问题和渲染时序问题导致列表 item 位移
    if (currentStatus != responseMsg.status) {
      _adjustPaddingAndScroll(
        isStreaming: true,
        changeStatus: true,
        onMeasureFinished: () {
          state.chatMessage.refresh();
          _adjustPaddingAndScroll(isStreaming: true);
        },
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.chatMessage.refresh();
        _adjustPaddingAndScroll(isStreaming: true);
      });
    }
  }

  /// 调整底部 padding 并执行滚动
  /// isStreaming: 用于区分是用户初次发送还是AI流式更新，以采用不同滚动动画
  void _adjustPaddingAndScroll({
    bool isStreaming = false,
    bool changeStatus = false,
    Function? onMeasureFinished,
  }) {
    // 等待当前帧渲染完成，确保向列表添加新项目后，Flutter有机会计算其大小和位置。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!listViewController.hasClients ||
          lastUserMsgKey.currentContext == null) {
        return;
      }

      final viewportHeight = listViewController.position.viewportDimension;
      if (viewportHeight <= 0) return;

      // 精确测量“固定块”的高度
      final userRenderBox =
          lastUserMsgKey.currentContext!.findRenderObject() as RenderBox;
      final userMessageHeight =
          userRenderBox.size.height + (6 * 2); // 6 是 Row 中 Container 的外边距

      double aiMessageHeight = 0.0;
      if (lastAIMsgKey.currentContext != null) {
        final aiRenderBox =
            lastAIMsgKey.currentContext!.findRenderObject() as RenderBox;
        aiMessageHeight = aiRenderBox.size.height;
      }

      // “固定块”的总高度 = 用户消息高 + AI消息高
      final double pinnedContentHeight = userMessageHeight + aiMessageHeight;

      // 核心计算：用视口高度减去“固定块”高度，得出需要的padding
      final double newPadding =
          viewportHeight -
          pinnedContentHeight -
          // 这里是因为布局里的最外层 Container 和 ListView 都加了 SafeArea ，所以要减去
          MediaQuery.of(lastUserMsgKey.currentContext!).padding.bottom -
          Get.mediaQuery.viewInsets.bottom;

      // 如果“固定块”比屏幕高，padding至少为0，不能是负数
      state.listBottomPadding.value = changeStatus
          ? viewportHeight
          : (newPadding > 0 ? newPadding : 0.0);

      if (changeStatus) {
        if (onMeasureFinished != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onMeasureFinished.call();
          });
        }
      } else {
        if (isStreaming) {
          // _scrollToBottom(!isStreaming);
        } else {
          _scrollToBottom(true);
        }
      }
    });
  }

  /// 完成响应
  Future<void> _finalizeResponse(ChatMessage responseMsg) async {
    responseMsg.status = ChatMessageStatus.success;
    state.chatMessage.refresh();

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertChatMessage(responseMsg);
    }

    // 更新 Token 用量信息
    await _repoDBApp.upsertAIModelConfig(
      state.currentAIModelConfig.value!
        ..tokenInput += responseMsg.tokenInput
        ..tokenOutput += responseMsg.tokenOutput,
    );

    HapticUtil.success();
    // rippleKey.currentState?.triggerRipple();

    _topicNaming();
  }

  /// 处理聊天错误
  void _handleChatError() {
    HapticUtil.error();
    // 可以在这里添加更多错误处理逻辑
  }

  /// 滚动思考内容到底部
  void scrollReasoningToBottom() {
    if (!reasoningController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_canScrollReasoning()) return;

      final position = reasoningController.position;
      final remainToBottom = position.extentAfter;

      if (_shouldAnimateScroll(remainToBottom)) {
        _animateReasoningScroll(position);
      }
    });
  }

  /// 检查是否可以滚动思考内容
  bool _canScrollReasoning() {
    return reasoningController.positions.length == 1 &&
        reasoningController.position.hasContentDimensions;
  }

  /// 判断是否需要动画滚动
  bool _shouldAnimateScroll(double remainToBottom) {
    return remainToBottom > reasoningTextHeight * 3;
  }

  /// 执行动画滚动
  void _animateReasoningScroll(ScrollPosition position) {
    if (!_currentReasoningScrollFinished) return;

    _currentReasoningScrollFinished = false;

    reasoningController
        .animateTo(
          position.maxScrollExtent - reasoningTextHeight,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        )
        .whenComplete(() => _currentReasoningScrollFinished = true);
  }

  /// 话题命名（首轮对话完成才会执行）
  void _topicNaming() async {
    if (state.isTemporaryChat.value) return;
    if (state.chatMessage.where((e) => e.role != ChatRole.system).length != 2) {
      return;
    }

    var modelConfig = state.currentAIModelConfig.value;
    var model = state.currentAIModel.value;
    if (GlobalStore.config.isValidTopicNamingModel) {
      // 若存在默认配置，则直接使用
      modelConfig = GlobalStore.config.topicNamingAIProvider;
      model = AIModel(id: GlobalStore.config.topicNamingAIProviderModelId!);
    }

    final result = await _repoNetAI.topicNaming(
      config: modelConfig!,
      model: model!,
      conversation: state.currentConversation.value!.copyWith(
        thinkType: AIThinkType.none,
      ),
      history: List.of([
        ChatMessage()
          ..role = ChatRole.system
          ..content = Prompts.topicNaming,
        ...state.chatMessage,
      ]),
    );
    if (result?.content == null) {
      return;
    }

    await _repoDBApp.upsertConversation(
      state.currentConversation.value!..title = result!.content!,
    );

    // 更新 Token 用量信息
    await _repoDBApp.upsertAIModelConfig(
      modelConfig
        ..tokenInput += result.tokenInput
        ..tokenOutput += result.tokenOutput,
    );

    Get.find<DrawerLogic>().refreshList();
  }

  void addFile(AddOptionsType type) async {
    switch (type) {
      case AddOptionsType.image:
        final image = await FilePickerUtil.pickImage();
        if (image != null) {
          state.selectedFiles.add(UploadImage(image));
        }
        break;
      case AddOptionsType.file:
        final file = await FilePickerUtil.pickFile();
        if (file != null) {
          state.selectedFiles.add(UploadFile(file));
        }
        break;
      case AddOptionsType.link:
        final result = await DialogUtil.showInputDialog(title: 'inputLink'.tr);
        if (result == null || result.trim().isEmpty) return;

        state.selectedFiles.add(UploadLink('', name: result));
        break;
    }
  }

  void copyAIMessage(ChatMessage msg) async {
    await Clipboard.setData(ClipboardData(text: msg.content?.trim() ?? ''));
    DialogUtil.showSnackBar('contentHasCopied'.tr);
  }

  void shareAIMessage(ChatMessage msg) async {
    SharePlus.instance.share(ShareParams(text: msg.content?.trim()));
  }

  void showAIMessageMore(ChatMessage msg) async {
    BlurBottomSheet.show(
      'Token 用量',
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Prompt 输入'),
            trailing: Text(
              NumberUtil.formatNumber(msg.tokenInput),
              style: TextStyle(fontSize: 14),
            ),
          ),
          ListTile(
            title: Text('AI 输出'),
            trailing: Text(
              NumberUtil.formatNumber(msg.tokenOutput),
              style: TextStyle(fontSize: 14),
            ),
          ),
          ListTile(
            title: Text('AI 思考'),
            trailing: Text(
              NumberUtil.formatNumber(msg.tokenReasoning),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
