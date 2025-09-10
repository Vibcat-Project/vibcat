import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/store.dart';
import '../../../widget/settings_panel.dart';
import 'logic.dart';

class WebSearchSettingsPage extends StatelessWidget {
  WebSearchSettingsPage({super.key});

  final logic = Get.put(WebSearchSettingsLogic());
  final state = Get.find<WebSearchSettingsLogic>().state;

  AppBar _appBar() => AppBar(title: Text('onlineSearch'.tr));

  Widget _body() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
      children: [
        SizedBox(height: 20),
        SettingsPanel(
          backgroundColor: GlobalStore.themeExt.container,
          items: [
            SettingsPanelItem(
              text: Text('webSearchEngine'.tr),
              trailing: Text(
                state.currentWebSearchEngine.value.plainText,
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => logic.onSelectWebSearchEngine(),
            ),
            if (state.currentWebSearchEngine.value.requiredAPIKey)
              SettingsPanelItem(
                text: Text('webSearchApiKey'.tr),
                trailing: Text(
                  state.currentWebSearchAPIKey.value.isEmpty
                      ? 'unset'.tr
                      : '●●●●',
                  style: TextStyle(fontSize: 10),
                ),
                onTap: () => logic.onInputAPIKey(),
              ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: Obx(() => _body()));
  }
}
