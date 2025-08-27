import 'dart:convert';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/enum/normal_dialog_button.dart';
import 'package:vibcat/util/dialog.dart';

import 'state.dart';

class OtherSettingsLogic extends GetxController {
  final OtherSettingsState state = OtherSettingsState();

  final _repoDBApp = Get.find<AppDBRepository>();

  void exportAllData() async {
    final map = await _repoDBApp.getAllConversationAndChatMassage();
    if (map.isEmpty) return;

    final exportDataList = [];

    for (final data in map.entries) {
      exportDataList.add({
        'title': data.key.title,
        'messages': data.value
            .map(
              (e) => {
                'role': e.role.name,
                'content': e.content,
                'timestamp': e.createdAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
      });
    }

    SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            utf8.encode(jsonEncode(exportDataList)),
            mimeType: 'text/plain',
          ),
        ],
        fileNameOverrides: ['data.txt'],
      ),
    );
  }

  void deleteAllData() async {
    final result = await DialogUtil.showNormalDialog('确定删除所有对话吗？');
    if (result != NormalDialogButton.ok) {
      return;
    }
  }
}
