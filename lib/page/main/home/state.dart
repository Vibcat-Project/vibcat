import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/ai_think_type.dart';

class HomeState {
  final showAppbarDivider = false.obs;

  final currentConversation = Rxn<Conversation>();
  final Rxn<AIModelConfig> currentAIModelConfig = Rxn<AIModelConfig>();
  final Rxn<AIModel> currentAIModel = Rxn<AIModel>();
  final chatMessage = <ChatMessage>[].obs;

  final thinkType = AIThinkType.none.obs;
  final isResponding = false.obs;
  final isTemporaryChat = false.obs;

  HomeState() {
    ///Initialize variables
  }
}
