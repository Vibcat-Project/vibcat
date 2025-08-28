import 'package:get/get.dart';
import 'package:vibcat/global/store.dart';

class SettingsState {
  final hapticFeedbackEnabled = GlobalStore.config.hapticFeedback.obs;

  SettingsState() {
    ///Initialize variables
  }
}
