import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/page/main/drawer/view.dart';
import 'package:vibcat/page/main/home/view.dart';
import 'package:vibcat/util/app.dart';
import 'package:vibcat/widget/slide_drawer.dart';

import '../../util/haptic.dart';
import 'logic.dart';
import 'state.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final MainLogic logic = Get.put(MainLogic());
  final MainState state = Get.find<MainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideDrawer(
        controller: logic.slideDrawerController,
        onDragStart: () => AppUtil.hideKeyboard(),
        onLeftSwipeThresholdTrig: () => HapticUtil.normal(),
        onLeftSwipeThresholdApply: () => logic.onLeftSwipeThresholdApply(),
        onSlideDrawerStateChanged: (_) => HapticUtil.soft(),
        drawer: DrawerComponent(),
        child: HomeComponent(),
      ),
    );
  }
}
