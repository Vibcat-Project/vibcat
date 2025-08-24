import 'package:get/get.dart';
import 'package:vibcat/enum/ai_provider_type.dart';

class AddModelProviderState {
  final currentAIProvider = AIProviderType.openAI.obs;
  final showErrorAPIEndPointText = false.obs;
  final showErrorAPIKeyText = false.obs;
  final showErrorCustomNameText = false.obs;

  AddModelProviderState() {
    ///Initialize variables
  }
}
