import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:json5/json5.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/repository/net/web_search.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/page/main/home/state.dart';
import 'package:vibcat/service/chat/chat_event.dart';
import 'package:vibcat/service/chat/response_builder.dart';

import '../../bean/chat_request.dart';
import '../../bean/upload_file.dart';
import '../../data/bean/ai_model.dart';
import '../../data/bean/questions.dart';
import '../../enum/ai_think_type.dart';
import '../../enum/chat_role.dart';
import '../../global/prompts.dart';
import '../../global/store.dart';
import '../../util/web_content_extractor.dart';

class ChatManager {
  final _aiService = Get.find<AINetRepository>();
  final _webSearchService = Get.find<WebSearchRepository>();
  final _databaseService = Get.find<AppDBRepository>();

  final ChatMessage userMsg;
  final ChatMessage responseMsg;
  final HomeState state;
  final bool isRetry;

  ChatManager({
    required this.userMsg,
    required this.responseMsg,
    required this.state,
    this.isRetry = false,
  });

  Stream<ChatEvent> sendMessage() async* {
    final request = ChatRequest(
      config: state.currentAIModelConfig.value!,
      model: state.currentAIModel.value!,
      conversation: state.currentConversation.value!,
      messages: List.of(state.chatMessage)..remove(responseMsg),
    );

    if (!isRetry) {
      yield* _processWebSearch(request);
    }

    final responseBuilder = ChatResponseBuilder();
    await for (final response in _aiService.chatCompletions(request)) {
      final event = responseBuilder.build(response);
      if (event is ErrorEvent) {
        yield event;
        return;
      }

      yield event;
    }

    // 保存到数据库
    // if (!isTemporary) {
    //   await _databaseService.upsertChatMessage(responseMsg);
    // }

    yield ChatEvent.completed();
  }

  Future<bool?> topicNaming() async {
    if (state.isTemporaryChat.value) return null;
    if (state.chatMessage.where((e) => e.role != ChatRole.system).length != 2) {
      return null;
    }

    var modelConfig = state.currentAIModelConfig.value;
    var model = state.currentAIModel.value;
    if (GlobalStore.config.isValidTopicNamingModel) {
      // 若存在默认配置，则直接使用
      modelConfig = GlobalStore.config.topicNamingAIProvider;
      model = AIModel(id: GlobalStore.config.topicNamingAIProviderModelId!);
    }

    final result = await _aiService.chatCompletionOnce(
      ChatRequest(
        config: modelConfig!,
        model: model!,
        conversation: state.currentConversation.value!.copyWith(
          thinkType: AIThinkType.none,
        ),
        messages: List.of([
          ChatMessage()
            ..role = ChatRole.system
            ..content = Prompts.topicNaming,
          ...state.chatMessage,
        ]),
      ),
    );
    if (!result.isSuccess) {
      return false;
    }

    await _databaseService.upsertConversation(
      state.currentConversation.value!..title = result.content!,
    );

    // 更新 Token 用量信息
    await _databaseService.upsertAIModelConfig(
      modelConfig
        ..tokenInput += result.tokenUsage.input
        ..tokenOutput += result.tokenUsage.output,
    );

    return true;
  }

  /// 处理联网相关
  Stream<ChatEvent> _processWebSearch(ChatRequest request) async* {
    var needProcess = false;

    // 处理用户主动添加的链接
    final links = userMsg.files.whereType<UploadLink>();
    if (links.isNotEmpty) {
      needProcess = true;

      for (final link in links) {
        yield ChatEvent.processing('visitingWebsite'.tr, desc: link.name);

        final result = await WebContentExtractor.extractContent(link.name);
        link.file = File(result ?? '');
      }
    }

    // 处理在线搜索功能
    if (state.enableWebSearch.value) {
      needProcess = true;
      yield ChatEvent.processing('generatingKeywords'.tr);

      final searchQuestions = await _generateSearchQuestions(request);
      if (searchQuestions != null) {
        yield* _executeSearchQuestions(searchQuestions);
      }
    }

    // 保存到数据库
    if (!state.isTemporaryChat.value) {
      await _databaseService.upsertChatMessage(userMsg);
    }

    if (needProcess) {
      yield ChatEvent.processing('waitingForAIResponse'.tr);
    }
  }

  /// 生成搜索问题
  Future<Questions?> _generateSearchQuestions(ChatRequest request) async {
    final res = await _aiService.chatCompletionOnce(
      ChatRequest(
        config: request.config,
        model: request.model,
        conversation: request.conversation,
        messages: [
          ChatMessage()
            ..role = ChatRole.system
            ..content = Prompts.webSearchKwRephraser,
          ChatMessage()
            ..role = ChatRole.user
            ..content = userMsg.content,
        ],
        additionalParams: Prompts.webSearchKwRephraserJsonSchema,
      ),
    );

    if (!res.isSuccess) return null;

    try {
      return Questions.fromJson(JSON5.parse(res.content!));
    } catch (e) {
      return null;
    }
  }

  /// 执行搜索问题
  Stream<ChatEvent> _executeSearchQuestions(Questions questions) async* {
    for (final question in questions.questions) {
      switch (question.type) {
        case QuestionType.summarize:
          yield* _processSummarizeQuestion(question);
          break;
        case QuestionType.webSearch:
          // TODO 这里会同时存在 links 和 query，需要进一步处理
          if (question.links.isNotEmpty) {
            yield* _processSummarizeQuestion(question);
          } else {
            yield* _processWebSearchQuestion(question);
          }
          break;
        case QuestionType.notNeeded:
          // Do nothing
          break;
      }
    }
  }

  /// 处理总结类型问题
  Stream<ChatEvent> _processSummarizeQuestion(Question question) async* {
    for (final url in question.links) {
      yield ChatEvent.processing('visitingWebsite'.tr, desc: url);

      final result = await WebContentExtractor.extractContent(url);
      userMsg.files.add(UploadWebSearch(result ?? '', name: url));
    }
  }

  /// 处理网络搜索类型问题
  Stream<ChatEvent> _processWebSearchQuestion(Question question) async* {
    yield ChatEvent.processing('searchingKeywords'.tr, desc: question.query);

    await for (final event in Stream.multi((controller) async {
      try {
        final kwResult = await _webSearchService.request(
          question.query,
          onVisitUrl: (url) {
            controller.add(
              ChatEvent.processing('visitingWebsite'.tr, desc: url),
            );
          },
        );

        // 处理搜索结果
        for (final value in kwResult) {
          userMsg.files.add(UploadWebSearch(value.content, name: value.url));
        }
      } finally {
        controller.close();
      }
    })) {
      yield event as ChatEvent;
    }
  }
}
