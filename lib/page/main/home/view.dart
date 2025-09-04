import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:vibcat/bean/upload_file.dart';
import 'package:vibcat/enum/ai_think_type.dart';
import 'package:vibcat/enum/chat_message_status.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/icons.dart';
import 'package:vibcat/global/images.dart';
import 'package:vibcat/global/lottie.dart';
import 'package:vibcat/global/markdown_config.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/widget/image_loader.dart';
import 'package:vibcat/widget/ripple_effect.dart';

import '../../../util/app.dart';
import '../logic.dart';
import 'logic.dart';
import 'state.dart';

class HomeComponent extends StatelessWidget {
  HomeComponent({super.key});

  final mainLogic = Get.find<MainLogic>();
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      key: logic.rippleKey,
      child: Scaffold(
        backgroundColor: AppColor.transparent,
        appBar: _buildAppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => AppUtil.hideKeyboard(),
          child: _buildBody(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        extendBody: true,
      ),
    );
  }

  // ==================== AppBar Section ====================

  AppBar _buildAppBar() {
    return AppBar(
      title: _buildAppBarTitle(),
      leading: _buildMenuButton(),
      actions: [_buildNewChatButton()],
      bottom: _buildAppBarDivider(),
    );
  }

  Widget _buildAppBarTitle() {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: Listenable.merge([logic.pulseController]),
        builder: (_, _) => Obx(() => _buildModelSelector()),
      ),
      onTap: () => logic.selectModel(),
    );
  }

  Widget _buildModelSelector() {
    final hasModel = state.currentAIModel.value != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.container,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: GlobalStore.themeExt.border!),
        boxShadow: hasModel ? null : _buildPulseBoxShadow(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasModel) ...[_buildModelIcon(), const SizedBox(width: 10)],
          _buildModelName(),
        ],
      ),
    );
  }

  List<BoxShadow> _buildPulseBoxShadow() {
    return [
      BoxShadow(
        color: AppColor.red.withOpacity(0.3 * logic.pulseController.value),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ];
  }

  Widget _buildModelIcon() {
    return ImageLoader.assets(
      name: state.currentAIModelConfig.value?.provider.icon ?? '',
      size: 14,
    );
  }

  Widget _buildModelName() {
    return Flexible(
      child: Text(
        state.currentAIModel.value?.id.split('/').last ?? 'appName'.tr,
        style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      onPressed: () => mainLogic.controlSlideDrawer(true),
      icon: Icon(AppIcon.menu),
    );
  }

  Widget _buildNewChatButton() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: IconButton(
        onPressed: () => logic.newConversation(true),
        icon: Icon(AppIcon.anonymous, fontWeight: FontWeight.bold),
      ),
    );
  }

  PreferredSizeWidget _buildAppBarDivider() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Obx(
        () => state.showAppbarDivider.value
            ? Container(height: 1, color: GlobalStore.themeExt.divider)
            : const SizedBox.shrink(),
      ),
    );
  }

  // ==================== Body Section ====================

  Widget _buildBody() {
    return Obx(
      () => state.chatMessage.isNotEmpty ? _buildChatBody() : _buildEmptyBody(),
    );
  }

  Widget _buildChatBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: LayoutBuilder(
          builder: (context, _) => Obx(
            () => ListView.builder(
              controller: logic.listViewController,
              padding: EdgeInsets.only(
                bottom: state.listBottomPadding.value,
              ).add(MediaQuery.of(context).padding),
              itemCount: state.chatMessage.length,
              itemBuilder: _buildChatItem,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyBody() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
      child: SafeArea(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(state.isTemporaryChat.value),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: _buildEmptyStateImage(),
        ),
      ),
    );
  }

  Widget _buildEmptyStateImage() {
    return state.isTemporaryChat.value
        ? ImageLoader.assets(name: AppImage.emojiPeekingEyes, size: 140)
        : ImageLoader.assets(name: AppImage.logo, size: 100);
  }

  Widget _buildChatItem(BuildContext context, int index) {
    final message = state.chatMessage[index];
    return message.role == ChatRole.user
        ? UserMessageWidget(
            message: message,
            index: index,
            isLastUserMessage: _isLastUserMessage(index),
            lastUserMsgKey: logic.lastUserMsgKey,
          )
        : AssistantMessageWidget(
            message: message,
            index: index,
            isLastMessage: index == state.chatMessage.length - 1,
            lastAIMsgKey: logic.lastAIMsgKey,
            logic: logic,
          );
  }

  bool _isLastUserMessage(int index) {
    return index == state.chatMessage.length - 1 ||
        (index == state.chatMessage.length - 2 &&
            state.chatMessage.last.role == ChatRole.assistant);
  }

  // ==================== Bottom Navigation Bar ====================

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Obx(() => _buildBottomBar()),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.container?.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GlobalStore.themeExt.border!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.selectedFiles.isNotEmpty) _buildSelectedFilesContainer(),
          _buildTextField(),
          const SizedBox(height: 10),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildSelectedFilesContainer() {
    return FileContainer(
      files: state.selectedFiles,
      height: 70,
      padding: const EdgeInsets.only(top: 10),
      onTap: (index) {
        state.selectedFiles.removeAt(index);
        state.selectedFiles.refresh();
      },
    );
  }

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'askSomething'.tr,
      ),
      minLines: 1,
      maxLines: 8,
      controller: logic.tePromptController,
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        _buildAddFileButton(),
        const SizedBox(width: 10),
        _buildThinkTypeButton(),
        const SizedBox(width: 10),
        _buildNetworkButton(),
        const Spacer(),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildAddFileButton() {
    return PopupMenuButton(
      color: GlobalStore.themeExt.container,
      elevation: 10,
      shadowColor: AppColor.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      itemBuilder: (_) => [
        PopupMenuItem(value: 'image', child: Text('addImage'.tr)),
        PopupMenuItem(value: 'file', child: Text('addFile'.tr)),
      ],
      onSelected: logic.addFile,
      child: RoundButton(icon: Icon(AppIcon.add)),
    );
  }

  Widget _buildThinkTypeButton() {
    final thinkType = state.thinkType.value;
    final isNoneType = thinkType == AIThinkType.none;

    return PopupMenuButton(
      color: GlobalStore.themeExt.container,
      elevation: 10,
      shadowColor: AppColor.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: RoundButton(
        icon: Icon(AppIcon.light),
        text: isNoneType ? 'think'.tr : thinkType.plainName.tr,
        color: isNoneType ? null : GlobalStore.themeExt.border,
      ),
      itemBuilder: (_) =>
          AIThinkType.values.map(_buildThinkTypeMenuItem).toList(),
      onSelected: (v) => logic.changeThinkType(v),
    );
  }

  PopupMenuItem _buildThinkTypeMenuItem(AIThinkType type) {
    return PopupMenuItem(
      value: type,
      child: Row(
        children: [
          Expanded(child: Text(type.plainName.tr)),
          if (type == state.thinkType.value)
            const Icon(CupertinoIcons.checkmark_alt_circle_fill, size: 18),
        ],
      ),
    );
  }

  Widget _buildNetworkButton() {
    return RoundButton(icon: Icon(AppIcon.network), text: '联网', onTap: () {});
  }

  Widget _buildSendButton() {
    return RoundButton(
      icon: Icon(
        state.isResponding.value ? AppIcon.stop : AppIcon.arrowUp,
        color: GlobalStore.themeExt.container,
        size: 18,
      ),
      color: GlobalStore.theme.colorScheme.primary,
      onTap: () => logic.chat(),
    );
  }
}

// ==================== 独立的消息组件 ====================

class UserMessageWidget extends StatelessWidget {
  final dynamic message;
  final int index;
  final bool isLastUserMessage;
  final GlobalKey? lastUserMsgKey;

  const UserMessageWidget({
    super.key,
    required this.message,
    required this.index,
    required this.isLastUserMessage,
    this.lastUserMsgKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.files.isNotEmpty) _buildAttachedFiles(),
        _buildMessageBubble(),
      ],
    );
  }

  Widget _buildAttachedFiles() {
    return FileContainer(files: message.files, height: 70, shrinkWrap: true);
  }

  Widget _buildMessageBubble() {
    return Row(
      key: isLastUserMessage ? lastUserMsgKey : null,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(maxWidth: Get.width * 0.8),
          decoration: BoxDecoration(
            color: GlobalStore.themeExt.container,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GlobalStore.themeExt.border!),
          ),
          child: SelectableText(
            message.content ?? '',
            style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            minLines: 1,
            maxLines: 4,
          ),
        ),
      ],
    );
  }
}

class AssistantMessageWidget extends StatelessWidget {
  final dynamic message;
  final int index;
  final bool isLastMessage;
  final GlobalKey? lastAIMsgKey;
  final HomeLogic logic;

  const AssistantMessageWidget({
    super.key,
    required this.message,
    required this.index,
    required this.isLastMessage,
    this.lastAIMsgKey,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: isLastMessage ? lastAIMsgKey : null,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasReasoning()) _buildReasoningSection(),
        _buildMessageContent(),
        if (_showActions()) _buildActionButtons(),
      ],
    );
  }

  bool _hasReasoning() =>
      message.reasoning != null && message.reasoning!.isNotEmpty;

  bool _showActions() => message.status == ChatMessageStatus.success;

  Widget _buildReasoningSection() {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: message.status == ChatMessageStatus.reasoning ? 0.0 : 1,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.topLeft,
          child: child,
        );
      },
      child: ReasoningContainer(
        message: message,
        isLastMessage: isLastMessage,
        logic: logic,
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.status == ChatMessageStatus.sending) {
      return _buildLoadingMessage();
    } else if (message.status == ChatMessageStatus.failed) {
      return _buildFailedMessage();
    }

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: MarkdownBlock(
        data: message.content ?? '',
        generator: MarkdownConfigs.generator,
        config: MarkdownConfigs.config,
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AppLottie.loadingRainbowCatWidget(),
        ),
      ],
    );
  }

  Widget _buildFailedMessage() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: GlobalStore.themeExt.border,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text('dataLoadFail'.tr, style: const TextStyle(fontSize: 15)),
        ),
        if (isLastMessage) _buildRetryButton(),
      ],
    );
  }

  Widget _buildRetryButton() {
    return IconButton(
      onPressed: () => logic.chat(true),
      icon: const Icon(Icons.refresh),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        spacing: 12,
        children: [
          MessageActionButton(
            icon: AppIcon.copy,
            onTap: () => logic.copyAIMessage(message),
          ),
          MessageActionButton(
            icon: AppIcon.share,
            onTap: () => logic.shareAIMessage(message),
          ),
          MessageActionButton(
            icon: AppIcon.more,
            onTap: () => logic.showAIMessageMore(message),
          ),
        ],
      ),
    );
  }
}

// ==================== 推理内容组件 ====================

class ReasoningContainer extends StatelessWidget {
  final dynamic message;
  final bool isLastMessage;
  final HomeLogic logic;

  const ReasoningContainer({
    super.key,
    required this.message,
    required this.isLastMessage,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.container3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildReasoningContent(),
      ),
    );
  }

  Widget _buildReasoningContent() {
    final isReasoning = message.status == ChatMessageStatus.reasoning;

    return isReasoning
        ? _buildReasoningInProgress()
        : _buildReasoningComplete();
  }

  Widget _buildReasoningInProgress() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black, Colors.transparent],
          stops: [0, 0.5, 1],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        height: logic.reasoningTextHeight * 4 + 20,
        padding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: logic.reasoningTextHeight * 4),
          child: SingleChildScrollView(
            controller: isLastMessage ? logic.reasoningController : null,
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                message.reasoning!.trim(),
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasoningComplete() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        'reasoningTimeConsuming'.trParams({
          'time': message.reasoningTimeConsuming ?? '',
        }),
      ),
    );
  }
}

// ==================== 通用组件 ====================

class RoundButton extends StatelessWidget {
  final double size;
  final Color? color;
  final Icon? icon;
  final String? text;
  final VoidCallback? onTap;

  const RoundButton({
    super.key,
    this.size = 32,
    this.color,
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCircle = text == null;
    final hasBorder = color == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCircle ? size : null,
        height: size,
        padding: isCircle ? null : const EdgeInsets.only(left: 4, right: 8),
        decoration: BoxDecoration(
          color: color,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          border: hasBorder
              ? Border.all(color: GlobalStore.themeExt.border!)
              : null,
          borderRadius: isCircle ? null : BorderRadius.circular(100),
        ),
        child: isCircle ? icon : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon!,
        if (text != null) Text(text!, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class MessageActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const MessageActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Icon(icon, size: 24));
  }
}

class FileContainer extends StatelessWidget {
  final List<UploadFileWrap> files;
  final double height;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final Function(int)? onTap;

  const FileContainer({
    super.key,
    required this.files,
    required this.height,
    this.padding,
    this.shrinkWrap = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + (padding?.vertical ?? 0),
      padding: padding,
      child: ListView.separated(
        shrinkWrap: shrinkWrap,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => FileItem(
          file: files[index],
          index: index,
          size: height,
          onTap: onTap,
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: files.length,
      ),
    );
  }
}

class FileItem extends StatelessWidget {
  final UploadFileWrap file;
  final int index;
  final double size;
  final Function(int)? onTap;

  const FileItem({
    super.key,
    required this.file,
    required this.index,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: file is UploadImage ? _buildImageFile() : _buildDocumentFile(),
    );
  }

  Widget _buildImageFile() {
    return ImageLoader.file(
      file: (file as UploadImage).file,
      size: size,
      borderRadius: 10,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDocumentFile() {
    const fontSize = 14.0;
    const lineHeight = 1.2;
    final maxLines = ((size - 8) / (fontSize * lineHeight)).floor();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.border,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        file.name,
        style: const TextStyle(
          fontSize: fontSize,
          height: lineHeight,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: maxLines,
      ),
    );
  }
}
