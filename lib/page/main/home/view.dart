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

import '../../../util/app.dart';
import '../logic.dart';
import 'logic.dart';
import 'state.dart';

class HomeComponent extends StatelessWidget {
  HomeComponent({super.key});

  final mainLogic = Get.find<MainLogic>();
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  AppBar _appBar() {
    return AppBar(
      title: GestureDetector(
        child: AnimatedBuilder(
          animation: Listenable.merge([logic.pulseController]),
          builder: (_, _) => Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: GlobalStore.themeExt.container,
                borderRadius: BorderRadius.circular(100),
                border: BoxBorder.all(color: GlobalStore.themeExt.border!),
                boxShadow: state.currentAIModel.value == null
                    ? [
                        BoxShadow(
                          color: AppColor.red.withOpacity(
                            0.3 * logic.pulseController.value,
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.currentAIModel.value != null) ...[
                    ImageLoader.assets(
                      name:
                          state.currentAIModelConfig.value?.provider.icon ?? '',
                      size: 14,
                    ),
                    SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      state.currentAIModel.value?.id.split('/').last ??
                          'appName'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () => logic.selectModel(),
      ),
      leading: IconButton(
        onPressed: () => mainLogic.controlSlideDrawer(true),
        icon: Icon(AppIcon.menu),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () => logic.newConversation(true),
            icon: Icon(AppIcon.anonymous, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Obx(
          () => state.showAppbarDivider.value
              ? Container(height: 1, color: GlobalStore.themeExt.divider)
              : Container(),
        ),
      ),
    );
  }

  Widget _chatBody() => Container(
    padding: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      // LayoutBuilder 是必须的
      child: LayoutBuilder(
        builder: (context, _) => Obx(
          () => ListView.builder(
            controller: logic.listViewController,
            padding: EdgeInsets.only(
              bottom: state.listBottomPadding.value,
            ).add(MediaQuery.of(context).padding),
            itemCount: state.chatMessage.length,
            itemBuilder: (context, index) {
              final item = state.chatMessage[index];
              final isLastItem = index == state.chatMessage.length - 1;

              if (item.role == ChatRole.user) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 图片、文件
                    if (item.files.isNotEmpty)
                      _buildFileContainer(item.files, 70, shrinkWrap: true),
                    // 用户发送的内容
                    Row(
                      key:
                          (index == state.chatMessage.length - 1 ||
                              (index == state.chatMessage.length - 2 &&
                                  state.chatMessage.last.role ==
                                      ChatRole.assistant))
                          ? logic.lastUserMsgKey
                          : null,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: Get.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: GlobalStore.themeExt.container,
                            borderRadius: BorderRadius.circular(20),
                            border: BoxBorder.all(
                              color: GlobalStore.themeExt.border!,
                            ),
                          ),
                          child: SelectableText(
                            item.content ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              if (item.status == ChatMessageStatus.sending) {
                return Row(
                  key: index == state.chatMessage.length - 1
                      ? logic.lastAIMsgKey
                      : null,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AppLottie.loadingRainbowCatWidget(),
                    ),
                  ],
                );
              } else if (item.status == ChatMessageStatus.failed) {
                return Wrap(
                  key: index == state.chatMessage.length - 1
                      ? logic.lastAIMsgKey
                      : null,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: GlobalStore.themeExt.border,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'dataLoadFail'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    if (isLastItem)
                      IconButton(
                        onPressed: () => logic.chat(true),
                        icon: Icon(Icons.refresh),
                      ),
                  ],
                );
              }

              return Column(
                key: index == state.chatMessage.length - 1
                    ? logic.lastAIMsgKey
                    : null,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 思考内容
                  if (item.reasoning != null && item.reasoning!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: GlobalStore.themeExt.border,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: item.status == ChatMessageStatus.reasoning
                                ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          // 顶部透明（渐变开始）
                                          Colors.transparent,
                                          // 中间完全可见
                                          Colors.black,
                                          // 底部透明（渐变结束）
                                          Colors.transparent,
                                        ],
                                        stops: [0, 0.5, 1], // 控制渐变区间
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          // 最大显示行数
                                          // maxHeight = fontSize * lineHeight * maxLines
                                          maxHeight:
                                              logic.reasoningTextHeight * 4,
                                        ),
                                        child: SingleChildScrollView(
                                          controller: isLastItem
                                              ? logic.reasoningController
                                              : null,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          // reverse: true,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              item.reasoning!.trim(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'reasoningTimeConsuming'.trParams({
                                        'time':
                                            item.reasoningTimeConsuming ?? '',
                                      }),
                                    ),
                                  ),
                          ),

                          // 顶部模糊层
                          // Positioned.fill(
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(15),
                          //     child: BackdropFilter(
                          //       filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.black.withOpacity(0.01),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: MarkdownBlock(
                      data: item.content ?? '',
                      generator: MarkdownConfigs.generator,
                      config: MarkdownConfigs.config,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );

  Widget _emptyBody() => Container(
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
        child: state.isTemporaryChat.value
            ? ImageLoader.assets(name: AppImage.emojiPeekingEyes, size: 140)
            : ImageLoader.assets(name: AppImage.logo, size: 100),
      ),
    ),
  );

  Widget _body() =>
      Obx(() => state.chatMessage.isNotEmpty ? _chatBody() : _emptyBody());

  Widget _roundButton({
    double? size = 32,
    Color? color,
    Icon? icon,
    String? text,
    Function()? onTap,
  }) {
    final circleStyle = text == null;
    final hasBorder = color == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleStyle ? size : null,
        height: size,
        padding: circleStyle ? null : EdgeInsets.only(left: 4, right: 8),
        decoration: BoxDecoration(
          color: color,
          shape: circleStyle ? BoxShape.circle : BoxShape.rectangle,
          border: hasBorder
              ? BoxBorder.all(color: GlobalStore.themeExt.border!)
              : null,
          borderRadius: circleStyle ? null : BorderRadius.circular(100),
        ),
        child: circleStyle
            ? icon // FittedBox(child: icon)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon ?? Container(),
                  // SizedBox(width: icon == null ? 0 : 2),
                  Text(text, style: TextStyle(fontSize: 14)),
                ],
              ),
      ),
    );
  }

  Widget _buildFile(
    UploadFileWrap file,
    int index,
    double size, {
    Function(int)? onTap,
  }) {
    final fontSize = 14.0;
    final lineHeight = 1.2;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: file is UploadImage
          ? ImageLoader.file(
              file: file.file,
              size: size,
              borderRadius: 10,
              fit: BoxFit.cover,
            )
          : Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: GlobalStore.themeExt.border,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: AlignmentGeometry.center,
              child: Text(
                file.name,
                style: TextStyle(
                  fontSize: fontSize,
                  height: lineHeight,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: ((size - 8) / (fontSize * lineHeight)).floor(),
              ),
            ),
    );
  }

  Widget _buildFileContainer(
    List<UploadFileWrap> list,
    double height, {
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Function(int)? onTap,
  }) {
    return Container(
      height: height + (padding?.vertical ?? 0),
      padding: padding,
      child: ListView.separated(
        shrinkWrap: shrinkWrap,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) =>
            _buildFile(list[index], index, height, onTap: onTap),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 10),
        itemCount: list.length,
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: GlobalStore.themeExt.container?.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: GlobalStore.themeExt.border!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.selectedFiles.isNotEmpty)
            _buildFileContainer(
              state.selectedFiles,
              70,
              padding: EdgeInsets.only(top: 10),
              onTap: (index) {
                state.selectedFiles.clear();
                state.selectedFiles.refresh();
              },
            ),
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'askSomething'.tr,
              // isDense: true,
            ),
            minLines: 1,
            maxLines: 8,
            controller: logic.tePromptController,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              PopupMenuButton(
                color: GlobalStore.themeExt.container,
                elevation: 10,
                shadowColor: AppColor.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'image', child: Text('addImage'.tr)),
                  PopupMenuItem(value: 'file', child: Text('addFile'.tr)),
                ],
                onSelected: logic.addFile,
                child: _roundButton(icon: Icon(AppIcon.add)),
              ),
              SizedBox(width: 10),
              PopupMenuButton(
                color: GlobalStore.themeExt.container,
                elevation: 10,
                shadowColor: AppColor.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: _roundButton(
                  icon: Icon(AppIcon.light),
                  text: state.thinkType.value == AIThinkType.none
                      ? 'think'.tr
                      : state.thinkType.value.plainName.tr,
                  color: state.thinkType.value == AIThinkType.none
                      ? null
                      : GlobalStore.themeExt.border,
                ),
                itemBuilder: (_) => AIThinkType.values
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            Expanded(child: Text(e.plainName.tr)),
                            if (e == state.thinkType.value)
                              Icon(
                                CupertinoIcons.checkmark_alt_circle_fill,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onSelected: (v) => logic.changeThinkType(v),
              ),
              SizedBox(width: 10),
              _roundButton(
                icon: Icon(AppIcon.network),
                text: '联网',
                onTap: () {},
              ),
              Spacer(),
              _roundButton(
                icon: Icon(
                  state.isResponding.value ? AppIcon.stop : AppIcon.arrowUp,
                  color: GlobalStore.themeExt.container,
                  size: 18,
                ),
                color: GlobalStore.theme.colorScheme.primary,
                onTap: () => logic.chat(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      appBar: _appBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => AppUtil.hideKeyboard(),
        child: _body(),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Obx(() => _bottomBar()),
          ),
        ),
      ),
      extendBody: true,
    );
  }
}
