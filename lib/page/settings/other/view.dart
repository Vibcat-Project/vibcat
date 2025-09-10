import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/constants.dart';
import 'package:vibcat/widget/settings_panel.dart';

import '../../../global/store.dart';
import 'logic.dart';
import 'state.dart';

class OtherSettingsPage extends StatelessWidget {
  OtherSettingsPage({super.key});

  final OtherSettingsLogic logic = Get.put(OtherSettingsLogic());
  final OtherSettingsState state = Get.find<OtherSettingsLogic>().state;

  AppBar _appBar() => AppBar(title: Text('otherSettings'.tr));

  Widget _body() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
      children: [
        SizedBox(height: 20),
        SettingsPanel(
          backgroundColor: GlobalStore.themeExt.container,
          title: Text('dataManagement'.tr),
          items: [
            SettingsPanelItem(
              text: Text('exportAllData'.tr),
              onTap: () => logic.exportAllData(),
            ),
            SettingsPanelItem(
              text: Text(
                'deleteAllData'.tr,
                style: TextStyle(color: AppColor.red),
              ),
              onTap: () => logic.deleteAllData(),
            ),
          ],
        ),
        SizedBox(height: 40),
        SettingsPanel(
          backgroundColor: GlobalStore.themeExt.container,
          title: Text('about'.tr),
          items: [
            SettingsPanelItem(
              text: Text('currentVersion'.tr),
              trailing: Obx(
                () => Text(
                  state.pkgInfo.value?.version ?? '',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            SettingsPanelItem(
              text: Text('githubOpenSourceRepo'.tr),
              onTap: () => logic.onOpenGithubRepo(),
            ),
            SettingsPanelItem(
              text: Text('communicationGroupQQ'.tr),
              trailing: Text(
                Constants.communicationGroupQQ,
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => logic.onCopyQQGroup(),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }
}
