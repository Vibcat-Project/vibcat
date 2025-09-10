import 'package:get/get.dart';
import 'package:vibcat/enum/web_search_type.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/util/dialog.dart';

import 'state.dart';

class WebSearchSettingsLogic extends GetxController {
  final WebSearchSettingsState state = WebSearchSettingsState();

  void onSelectWebSearchEngine() async {
    final result = await DialogUtil.showOptionBottomSheet(
      WebSearchType.values
          .map((e) => OptionBottomSheetItem(e.plainText, e))
          .toList(),
    );
    if (result == null) return;

    state.currentWebSearchEngine.value = result;

    // 不需要 API Key 的搜索引擎直接应用保存
    if (!result.requiredAPIKey) {
      state.currentWebSearchAPIKey.value = "";
      GlobalStore.saveConfig(
        GlobalStore.config
          ..webSearchType = result
          ..webSearchApiKey = "",
      );
    }
  }

  void onInputAPIKey() async {
    final result = await DialogUtil.showInputDialog();
    if (result == null || result.trim().isEmpty) return;

    state.currentWebSearchAPIKey.value = result.trim();

    GlobalStore.saveConfig(
      GlobalStore.config
        ..webSearchType = state.currentWebSearchEngine.value
        ..webSearchApiKey = result.trim(),
    );
  }
}
