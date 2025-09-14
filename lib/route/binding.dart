import 'package:get/get.dart';
import 'package:vibcat/data/repository/database/app_config_db.dart';
import 'package:vibcat/data/repository/database/app_db.dart';
import 'package:vibcat/data/repository/net/ai.dart';
import 'package:vibcat/data/repository/net/web_search.dart';
import 'package:vibcat/service/spotlight/spotlight.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SpotlightService());

    Get.lazyPut(() => AppConfigDBRepository(), fenix: true);
    Get.lazyPut(() => AppDBRepository(), fenix: true);
    Get.lazyPut(() => AINetRepository(), fenix: true);
    Get.lazyPut(() => WebSearchRepository(), fenix: true);
  }
}
