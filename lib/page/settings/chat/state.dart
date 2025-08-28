import 'package:get/get.dart';

import '../../../global/store.dart';

class ChatSettingsState {
  final newConvUseLastModel = GlobalStore.config.newConvUseLastModel.obs;

  ChatSettingsState() {
    ///Initialize variables
  }
}
