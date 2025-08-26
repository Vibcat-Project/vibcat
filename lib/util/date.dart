import 'package:intl/intl.dart';

class DateUtil {
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final diff = now.difference(dateTime);
    final diffDays = diff.inDays;

    // 1. 当天
    if (target == today) {
      return DateFormat('HH:mm').format(dateTime);
    }

    // 2. 本周内（不是今天）
    final startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    ); // 本周一
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // 本周日
    if (dateTime.isAfter(startOfWeek) &&
        dateTime.isBefore(endOfWeek.add(const Duration(days: 1)))) {
      // 星期几
      const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
      return '星期${weekdays[dateTime.weekday - 1]}';
    }

    // 3. 上周或一个月内 → X天前
    if (diffDays < 30) {
      return '$diffDays 天前';
    }

    // 4. 超过一个月 → yyyy/MM/dd
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }
}
