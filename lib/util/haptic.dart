import 'package:gaimon/gaimon.dart';

class HapticUtil {
  static Future<bool> get canSupportsHaptic async {
    return await Gaimon.canSupportsHaptic;
  }

  static void normal() async {
    if (await canSupportsHaptic) {
      Gaimon.medium();
    }
  }

  static void soft() async {
    if (await canSupportsHaptic) {
      Gaimon.soft();
    }
  }

  static void success() async {
    if (await canSupportsHaptic) {
      Gaimon.success();
    }
  }

  static void error() async {
    if (await canSupportsHaptic) {
      Gaimon.error();
    }
  }
}
