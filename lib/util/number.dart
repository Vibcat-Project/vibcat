class NumberUtil {
  static String formatNumber(int? number, {bool chinese = false}) {
    if (number == null) return '';
    if (number < 10000) return number.toString();

    if (chinese) {
      if (number < 100000000) {
        int value = number ~/ 10000; // 万
        return "$value万";
      } else {
        int value = number ~/ 100000000; // 亿
        return "$value亿";
      }
    } else {
      if (number < 1000000) {
        int value = number ~/ 1000; // 千
        return "${value}k";
      } else if (number < 1000000000) {
        int value = number ~/ 1000000; // 百万
        return "${value}m";
      } else {
        int value = number ~/ 1000000000; // 十亿
        return "${value}b";
      }
    }
  }

  static int parseInt(String? text) {
    if (text == null) return 0;

    return int.tryParse(text) ?? 0;
  }
}
