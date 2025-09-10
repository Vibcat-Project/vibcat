import 'dart:convert';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/enum/normal_dialog_button.dart';
import 'package:vibcat/global/constants.dart';
import 'package:vibcat/util/dialog.dart';

import '../../../util/app.dart';
import 'state.dart';

class OtherSettingsLogic extends GetxController {
  final OtherSettingsState state = OtherSettingsState();

  final _repoDBApp = Get.find<AppDBRepository>();

  @override
  void onInit() async {
    super.onInit();

    final pkgInfo = await PackageInfo.fromPlatform();
    state.pkgInfo.value = pkgInfo;
  }

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
    final result = await DialogUtil.showNormalDialog('sureToDeleteAllData'.tr);
    if (result != NormalDialogButton.ok) {
      return;
    }
  }

  void onOpenGithubRepo() async {
    final result = await launchUrlString(Constants.githubRepoLink);
    if (!result) {
      DialogUtil.showSnackBar('linkLaunchFailed'.tr);
    }
  }

  void onCopyQQGroup() async {
    await AppUtil.copyToClipboard(Constants.communicationGroupQQ);
    DialogUtil.showSnackBar('contentHasCopied'.tr);
  }
}
