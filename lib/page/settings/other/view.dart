import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';
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
          title: Text('数据管理'),
          items: [
            SettingsPanelItem(
              text: Text('导出所有对话'),
              onTap: () => logic.exportAllData(),
            ),
            SettingsPanelItem(
              text: Text('删除所有对话', style: TextStyle(color: AppColor.red)),
              onTap: () => logic.deleteAllData(),
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
