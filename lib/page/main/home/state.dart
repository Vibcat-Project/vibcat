import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/ai_think_type.dart';
import 'package:vibcat/global/store.dart';

class HomeState {
  final showAppbarDivider = false.obs;

  // 用于动态控制 ListView 底部间距的状态变量
  final listBottomPadding = 0.0.obs;
  final currentConversation = Rxn<Conversation>();

  // final Rxn<AIModelConfig> currentAIModelConfig = Rxn<AIModelConfig>();
  // final Rxn<AIModel> currentAIModel = Rxn<AIModel>();
  final Rxn<AIModelConfig> currentAIModelConfig = Rxn(
    GlobalStore.config.defaultConvAIProvider,
  );
  final Rxn<AIModel> currentAIModel = Rxn<AIModel>(
    GlobalStore.config.isValidDefaultConvModel
        ? AIModel(id: GlobalStore.config.defaultConvAIProviderModelId!)
        : null,
  );
  final chatMessage = <ChatMessage>[].obs;

  final thinkType = AIThinkType.none.obs;
  final isResponding = false.obs;
  final isTemporaryChat = false.obs;

  HomeState() {
    ///Initialize variables
  }
}
