import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/config.dart';
import 'package:vibcat/global/icons.dart';
import 'package:vibcat/global/markdown_config.dart';
import 'package:vibcat/global/store.dart';

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
        child: Text('Vibcat'),
        onTap: () => logic.getModelList(),
      ),
      leading: IconButton(
        onPressed: () => mainLogic.controlSlideDrawer(true),
        icon: Icon(AppIcon.menu),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () {},
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

  Widget _body() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        child: ListView.builder(
          controller: logic.listViewController,
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 0 || index == 2) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: GlobalStore.themeExt.container,
                        borderRadius: BorderRadius.circular(20),
                        border: BoxBorder.all(
                          color: GlobalStore.themeExt.border!,
                        ),
                      ),
                      child: Text(
                        '看啥客服加上发空间啊好疯狂了蝴蝶酥分即可恢复加上好疯狂就是对方可接受的发的啥开房间咖啡看啦凤凰科技大厦 asafagasgagadgadgadg 阿哥 昂啊好看就是发空间啊发的卡上',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: MarkdownBlock(
                      data: index == 1
                          ? Config.markdownText2
                          : Config.markdownText,
                      generator: MarkdownConfigs.generator,
                      config: MarkdownConfigs.config,
                      // style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _roundButton({
    double? size = 32,
    Color? color,
    Icon? icon,
    String? text,
  }) {
    final circleStyle = text == null;
    final hasBorder = color == null;

    return Container(
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
                Text(text, style: TextStyle(fontSize: 12)),
              ],
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
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'askSomething'.tr,
            ),
            minLines: 1,
            maxLines: 8,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _roundButton(icon: Icon(AppIcon.add)),
              SizedBox(width: 10),
              _roundButton(
                icon: Icon(AppIcon.light),
                text: '深度思考',
                color: GlobalStore.themeExt.border,
              ),
              SizedBox(width: 10),
              _roundButton(icon: Icon(AppIcon.network), text: '联网'),
              Spacer(),
              _roundButton(
                icon: Icon(
                  AppIcon.arrowUp,
                  color: GlobalStore.themeExt.container,
                  size: 18,
                ),
                color: GlobalStore.theme.primaryColor,
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
      body: _body(),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: _bottomBar(),
          ),
        ),
      ),
      extendBody: true,
    );
  }
}
