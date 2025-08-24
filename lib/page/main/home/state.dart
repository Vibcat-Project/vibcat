import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';

class HomeState {
  final showAppbarDivider = false.obs;
  final Rxn<AIModelConfig> currentAIModelConfig = Rxn<AIModelConfig>();
  final Rxn<AIModel> currentAIModel = Rxn<AIModel>();
  final chatMessage = <ChatMessage>[].obs;
  final isResponding = false.obs;

  HomeState() {
    ///Initialize variables
  }
}
