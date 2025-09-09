import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:json5/json5.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/repository/net/web_search.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/service/chat/chat_event.dart';
import 'package:vibcat/service/chat/response_builder.dart';

import '../../bean/chat_request.dart';
import '../../bean/upload_file.dart';
import '../../data/bean/questions.dart';
import '../../enum/chat_role.dart';
import '../../global/prompts.dart';
import '../../util/web_content_extractor.dart';

class ChatManager {
  final _aiService = Get.find<AINetRepository>();
  final _webSearchService = Get.find<WebSearchRepository>();
  final _databaseService = Get.find<AppDBRepository>();

  final ChatMessage userMsg;
  final ChatMessage responseMsg;
  final bool enableWebSearch;
  final bool isTemporary;

  ChatManager({
    required this.userMsg,
    required this.responseMsg,
    this.enableWebSearch = false,
    this.isTemporary = false,
  });

  Stream<ChatEvent> sendMessage(ChatRequest request) async* {
    try {
      // 处理用户主动添加的链接
      final links = userMsg.files.whereType<UploadLink>();
      if (links.isNotEmpty) {
        for (final link in links) {
          yield ChatEvent.processing('visitingWebsite'.tr, desc: link.name);

          final result = await WebContentExtractor.extractContent(link.name);
          link.file = File(result ?? '');
        }
      }

      // 处理在线搜索功能
      if (enableWebSearch) {
        yield ChatEvent.processing('generatingKeywords'.tr);

        final searchQuestions = await _generateSearchQuestions(request);
        if (searchQuestions != null) {
          yield* _executeSearchQuestions(searchQuestions);
        }
      }

      // 保存到数据库
      if (!isTemporary) {
        await _databaseService.upsertChatMessage(userMsg);
      }

      // 发送到AI服务
      // yield ChatEvent.aiResponding();

      final responseBuilder = ChatResponseBuilder();
      await for (final response in _aiService.chatCompletions(request)) {
        final event = responseBuilder.build(response);
        if (event != null) yield event;
      }

      // 保存到数据库
      if (!isTemporary) {
        await _databaseService.upsertChatMessage(responseMsg);
      }

      yield ChatEvent.completed(responseBuilder.finalMessage);
    } catch (e) {
      yield ChatEvent.error(e.toString());
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

    if (res == null) return null;

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
          // 大模型的指令遵循可能不太理想，对于用户发送的信息中包含链接的情况，可能会被解析为搜索模式，而不是基于链接去回答，所以这里简单判断下，只要 links 不为空，就直接使用总结模式
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
    final controller = StreamController<ChatEvent>();

    controller.add(
      ChatEvent.processing('searchingKeywords'.tr, desc: question.query),
    );

    final kwResult = await _webSearchService.request(
      question.query,
      onVisitUrl: (url) {
        // 在回调里不能 yield，但可以往 controller 里 add
        controller.add(ChatEvent.processing('visitingWebsite'.tr, desc: url));
      },
    );

    // 处理搜索结果
    for (final value in kwResult) {
      userMsg.files.add(UploadWebSearch(value.content, name: value.url));
    }

    // 关闭 controller
    await controller.close();

    // 把 controller.stream 的事件传递出去
    yield* controller.stream;
  }
}
