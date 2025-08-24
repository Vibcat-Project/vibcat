import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/icons.dart';
import 'package:vibcat/global/store.dart';

import '../../../global/color.dart';
import '../logic.dart';
import 'logic.dart';
import 'state.dart';

class DrawerComponent extends StatelessWidget {
  DrawerComponent({super.key});

  final mainLogic = Get.find<MainLogic>();
  final DrawerLogic logic = Get.put(DrawerLogic());
  final DrawerState state = Get.find<DrawerLogic>().state;

  AppBar _appBar() {
    return AppBar(
      title: Container(
        height: kToolbarHeight - 10,
        decoration: BoxDecoration(
          color: GlobalStore.themeExt.container2,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 10),
              child: Icon(AppIcon.search),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search'.tr,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () => mainLogic.controlSlideDrawer(false),
            icon: Icon(AppIcon.close),
          ),
        ),
      ],
    );
  }

  Widget _bottom() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(16, 0, 16, Get.mediaQuery.padding.bottom),
      child: GestureDetector(
        // 支持空白区域也能响应点击事件
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            Icon(AppIcon.settings, size: 32),
            SizedBox(width: 8),
            Text(
              'settings'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GlobalStore.themeExt.border,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
        onTap: () => logic.showSettingsSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      appBar: _appBar(),
      bottomNavigationBar: _bottom(),
    );
  }
}
