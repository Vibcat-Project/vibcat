import 'package:get/get.dart';
import 'package:spotlight/ext.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:vibcat/enum/tray_menu_item.dart';
import 'package:vibcat/page/main/home/logic.dart';
import 'package:window_manager/window_manager.dart';

import '../../widget/slide_drawer.dart';
import 'state.dart';

class MainLogic extends GetxController with TrayListener, WindowListener {
  final MainState state = MainState();

  final slideDrawerController = SlideDrawerController();

  @override
  void onInit() {
    super.onInit();

    trayManager.addListener(this);
    windowManager.addListener(this);
  }

  void controlSlideDrawer(bool open) {
    if (open) {
      slideDrawerController.openDrawer();
    } else {
      slideDrawerController.closeDrawer();
    }
  }

  void onLeftSwipeThresholdApply() {
    Get.find<HomeLogic>().newConversation();
  }

  // 切换窗口显示/隐藏
  Future<void> _toggleWindow() async {
    bool isVisible = await windowManager.isVisible();
    if (isVisible) {
      await windowManager.hide();
    } else {
      await _showWindow();
    }
  }

  // 显示窗口
  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconMouseDown() {
    _toggleWindow();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key?.toEnum(TrayMenuItem.values)) {
      case TrayMenuItem.show:
        _showWindow();
      case TrayMenuItem.exit:
        await windowManager.destroy();
        break;
      default:
        break;
    }
  }

  @override
  void onWindowClose() async {
    final isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      await windowManager.hide();
    }
  }

  @override
  void onClose() {
    slideDrawerController.dispose();

    trayManager.removeListener(this);
    windowManager.removeListener(this);

    super.onClose();
  }
}
