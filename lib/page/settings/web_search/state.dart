import 'package:get/get.dart';
import 'package:vibcat/global/store.dart';

class WebSearchSettingsState {
  final currentWebSearchEngine = GlobalStore.config.webSearchType.obs;
  final currentWebSearchAPIKey = GlobalStore.config.webSearchApiKey.obs;

  WebSearchSettingsState() {
    ///Initialize variables
  }
}
