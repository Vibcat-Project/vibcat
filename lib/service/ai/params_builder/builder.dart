import 'package:vibcat/bean/chat_request.dart';
import 'package:vibcat/enum/chat_role.dart';
import 'package:vibcat/ext/string.dart';
import 'package:vibcat/global/prompts.dart';
import 'package:vibcat/service/ai/params_builder/thinking_strategy.dart';
import 'package:vibcat/util/json.dart';

import '../../../bean/upload_file.dart';
import '../../../data/schema/chat_message.dart';
import '../../../util/file.dart';

class ChatRequestParamsBuilder {
  static Future<Map<String, dynamic>> build(
    ChatRequest request, {
    bool stream = true,
    bool ignoreThinking = false,
  }) async {
    final baseParams = await _buildBaseParams(request, stream);
    final thinkingParams = ignoreThinking ? {} : _buildThinkingParams(request);

    return {...baseParams, ...thinkingParams, ...?request.additionalParams};
  }

  static Future<Map<String, dynamic>> _buildBaseParams(
    ChatRequest request,
    bool stream,
  ) async {
    return {
      'model': request.model.id,
      'messages': await _transformMessages(request.messages),
      'stream': stream,
      'stream_options': {'include_usage': true},
    };
  }

  static Map<String, dynamic> _buildThinkingParams(ChatRequest request) {
    final strategy = ThinkingStrategy.create(request.config.provider);
    return strategy.buildParams(request);
  }

  static Future<List> _transformMessages(List<ChatMessage> messages) async {
    // 找出最后一个 user 消息的下标
    final lastUserIndex = messages.lastIndexWhere(
      (m) => m.role == ChatRole.user,
    );

    return await Future.wait(
      messages.asMap().entries.map((entry) async {
        final index = entry.key;
        final item = entry.value;

        // 只处理最后一个 user 的 files
        if (item.role == ChatRole.user &&
            index == lastUserIndex &&
            item.files.isNotEmpty) {
          final images = [];
          final references = [];

          await Future.wait(
            item.files.map((e) async {
              if (e is UploadImage) {
                images.add({
                  'type': 'image_url',
                  'image_url': {
                    'url': await FileUtil.fileToBase64DataUri(
                      e.file,
                      mimeType: e.mimeType,
                    ),
                  },
                });
              } else {
                final isFile = e is UploadFile;
                references.add({
                  'id': references.length + 1,
                  'type': isFile ? 'file' : 'link',
                  'content': isFile
                      ? await FileUtil.readFileAsString(e.file.path)
                      : e.file.path,
                  isFile ? 'name' : 'url': e.name,
                });
              }
            }),
          );

          final contents = [...images];

          if (references.isNotEmpty) {
            contents.add({
              'type': 'text',
              'text': Prompts.webSearchPrompt.renderTemplate({
                'USER_PROMPT': item.content ?? '',
                'REFERENCE_MATERIAL': JsonUtil.listToJson(references),
              }),
            });
          } else {
            contents.add({'type': 'text', 'text': item.content});
          }

          return {'role': item.role.name, 'content': contents};
        }

        // 其它情况：保留文本，忽略 files
        return {'role': item.role.name, 'content': item.content};
      }),
    );
  }

  // static Future<List> _transformMessages(List<ChatMessage> messages) async =>
  //     await Future.wait(
  //       messages.map((item) async {
  //         if (item.files.isNotEmpty) {
  //           final images = [];
  //           final references = [];
  //
  //           await Future.wait(item.files.map((e) async {
  //             if (e is UploadImage) {
  //               images.add({
  //                 'type': 'image_url',
  //                 'image_url': {
  //                   'url': await FileUtil.fileToBase64DataUri(
  //                     e.file,
  //                     mimeType: e.mimeType,
  //                   ),
  //                 },
  //               });
  //             } else {
  //               final isFile = e is UploadFile;
  //
  //               references.add({
  //                 'id': references.length + 1,
  //                 'type': isFile ? 'file' : 'link',
  //                 'content': isFile
  //                     ? await FileUtil.readFileAsString(e.file.path)
  //                     : e.file.path,
  //                 isFile ? 'name' : 'url': e.name,
  //               });
  //             }
  //           }));
  //
  //           final contents = [...images];
  //
  //           if (references.isNotEmpty) {
  //             contents.add({
  //               'type': 'text',
  //               'text': Prompts.webSearchPrompt.renderTemplate({
  //                 'USER_PROMPT': item.content ?? '',
  //                 'REFERENCE_MATERIAL': JsonUtil.listToJson(references),
  //               }),
  //             });
  //           } else {
  //             contents.add({'type': 'text', 'text': item.content});
  //           }
  //
  //           return {'role': item.role.name, 'content': contents};
  //         } else {
  //           return {'role': item.role.name, 'content': item.content};
  //         }
  //       }),
  //     );

  // static Future<List> _transformMessages(
  //   List<ChatMessage> messages,
  // ) async => await Future.wait(
  //   messages.map((item) async {
  //     if (item.files.isNotEmpty) {
  //       final contents = [
  //         {'type': 'text', 'text': item.content},
  //         ...await Future.wait(
  //           item.files.map((e) async {
  //             return switch (e) {
  //               UploadImage() => {
  //                 'type': 'image_url',
  //                 'image_url': {
  //                   'url': await FileUtil.fileToBase64DataUri(
  //                     e.file,
  //                     mimeType: e.mimeType,
  //                   ),
  //                 },
  //               },
  //               UploadFile() => {
  //                 // 'type': 'file',
  //                 // 'file': {
  //                 //   'file_data': await FileUtil.fileToBase64DataUri(
  //                 //     e.file,
  //                 //     mimeType: e.mimeType,
  //                 //   ),
  //                 // },
  //                 'type': 'text',
  //                 'text':
  //                     '${e.name}\n${await FileUtil.readFileAsString(e.file.path)}',
  //               },
  //               UploadLink() => {
  //                 'type': 'text',
  //                 'text': '${e.name}\n${e.file.path}',
  //               },
  //               UploadWebSearch() => {
  //                 'type': 'text',
  //                 'text': '${e.name}\n${e.file.path}',
  //               },
  //             };
  //           }),
  //         ),
  //       ];
  //
  //       return {'role': item.role.name, 'content': contents};
  //     } else {
  //       return {'role': item.role.name, 'content': item.content};
  //     }
  //   }),
  // );
}
