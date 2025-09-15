import 'package:get/get.dart';
import 'package:spotlight/spotlight.dart';
import 'package:spotlight/spotlight_platform_interface.dart';
import 'package:vibcat/bean/chat_request.dart';
import 'package:vibcat/data/bean/ai_model.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/global/prompts.dart';
import 'package:vibcat/global/store.dart';

import '../../data/repository/net/ai.dart';
import '../chat/chat_event.dart';
import '../chat/response_builder.dart';

class SpotlightService extends GetxService {
  @override
  void onInit() {
    super.onInit();

    Spotlight.setOnCallHandler((type, input, updater) async {
      switch (type) {
        case CallHandlerType.onTranslate:
          _translate(input, updater);
          break;
        default:
          break;
      }
    });
  }

  void _translate(String text, ResultUpdater updater) async {
    if (!GlobalStore.config.isValidDefaultConvModel) {
      updater
        ..update('addDefaultConversationModelFirst'.tr)
        ..finished();
      return;
    }

    final stream = Get.find<AINetRepository>().chatCompletions(
      ChatRequest(
        config: GlobalStore.config.defaultConvAIProvider!,
        model: AIModel(id: GlobalStore.config.defaultConvAIProviderModelId!),
        conversation: Conversation(),
        messages: [
          ChatMessage()
            ..role = ChatRole.system
            ..content = Prompts.translate,
          ChatMessage()
            ..role = ChatRole.user
            ..content = text,
        ],
        cancelToken: null,
      ),
    );

    final responseBuilder = ChatResponseBuilder();
    await for (final response in stream) {
      final event = responseBuilder.build(response);
      if (event is ErrorEvent) {
        updater.update('${'translationFailed'.tr}: \n${event.message.trim()}');
        break;
      }

      if (event is ContentEvent) {
        updater.update(event.content.trimRight());
      }
    }

    updater.finished();
  }
}
