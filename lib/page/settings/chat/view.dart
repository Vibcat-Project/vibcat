import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/store.dart';
import '../../../widget/settings_panel.dart';
import 'logic.dart';
import 'state.dart';

class ChatSettingsPage extends StatelessWidget {
  ChatSettingsPage({super.key});

  final ChatSettingsLogic logic = Get.put(ChatSettingsLogic());
  final ChatSettingsState state = Get.find<ChatSettingsLogic>().state;

  AppBar _appBar() => AppBar(title: Text('conversationSettings'.tr));

  String? _limitText(String? text, [int maxLength = 14]) {
    if (text == null) return null;
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}…";
  }

  Widget _body() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
      children: [
        SizedBox(height: 20),
        SettingsPanel(
          backgroundColor: GlobalStore.themeExt.container,
          items: [
            SettingsPanelItem(
              text: Text('话题命名模型'),
              trailing: Text(
                _limitText(
                      GlobalStore.config.topicNamingAIProviderModelId
                          ?.split('/')
                          .last,
                    ) ??
                    '未设置',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => logic.selectModel(0),
            ),
            SettingsPanelItem(
              text: Text('默认对话模型'),
              trailing: Text(
                _limitText(
                      GlobalStore.config.defaultConvAIProviderModelId
                          ?.split('/')
                          .last,
                    ) ??
                    '未设置',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => logic.selectModel(1),
            ),
            SettingsPanelItem(
              text: Text('新对话使用上一次模型'),
              trailing: Switch(
                value: state.newConvUseLastModel.value,
                onChanged: logic.onNewConvUseLastModelChanged,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: GetBuilder<ChatSettingsLogic>(builder: (_) => _body()),
    );
  }
}
