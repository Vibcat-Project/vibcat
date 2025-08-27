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
  late AnimationController pulseController;

  final _repoDBApp = Get.find<AppDBRepository>();
  final _repoNetAI = Get.find<AINetRepository>();

  // fontSize * lineHeight
  final double reasoningTextHeight = 14 * 1.4;

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
      ..chatMessage.clear();
    // state.currentAIModelConfig.value = null;
    // state.currentAIModel.value = null;

    // 通知 DrawerLogic 继续处理逻辑
    Get.find<DrawerLogic>().refreshList(newConv: true);
  }

  /// 加载对话
  Future<void> loadConversation(Conversation conversation) async {
    state
      ..isTemporaryChat.value = false
      ..currentConversation.value = conversation;

    // 加载 AI 模型配置
    await _loadConversationModel(conversation);

    // 加载聊天消息
    await _loadChatMessages(conversation);

    // 滚动到底部
    _scrollToBottom();
  }

  /// 加载对话的 AI 模型配置
  Future<void> _loadConversationModel(Conversation conversation) async {
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
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listViewController.hasClients) {
        listViewController.jumpTo(listViewController.position.maxScrollExtent);
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
        await _addUserMessage(conv, prompt);
        tePromptController.clear();
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
  Future<void> _addUserMessage(Conversation conv, String prompt) async {
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
    dynamic delta,
    ChatMessage responseMsg,
  ) async {
    responseMsg
      ..status = ChatMessageStatus.streaming
      ..content = (responseMsg.content ?? '') + (delta.content ?? '');

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

    state.chatMessage.refresh();
  }

  /// 完成响应
  Future<void> _finalizeResponse(ChatMessage responseMsg) async {
    responseMsg.status = ChatMessageStatus.success;
    state.chatMessage.refresh();

    if (!state.isTemporaryChat.value) {
      await _repoDBApp.upsertChatMessage(responseMsg);
    }

    HapticUtil.success();
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
}
