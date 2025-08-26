import 'package:get/get.dart';
import 'package:vibcat/page/main/home/logic.dart';

import '../../widget/slide_drawer.dart';
import 'state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  final slideDrawerController = SlideDrawerController();

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

  @override
  void onClose() {
    slideDrawerController.dispose();
    super.onClose();
  }
}
