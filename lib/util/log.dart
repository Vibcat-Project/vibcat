import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum _LogLevel {
  debug("🔍", "DEBUG"),
  info('ℹ️', 'INFO'),
  warning('⚠️', 'WARNING'),
  success('✅', 'SUCCESS'),
  error('❌', 'ERROR');

  final String emoji;
  final String upperName;

  const _LogLevel(this.emoji, this.upperName);
}

/// 日志工具类
class LogUtil {
  static const int _chunkSize = 800;
  static const _borderTop = "╔═══════════════════════════════════════════════";
  static const _borderBottom =
      "╚═══════════════════════════════════════════════";

  static void _printer(String message, _LogLevel level) {
    developer.log(message, name: 'VIBCAT_${level.upperName}');
  }

  static void _print(
    _LogLevel level,
    String message, {
    bool preserveIndent = true,
  }) {
    if (!kDebugMode) return;

    final time = DateTime.now().toString().substring(11, 19); // 只显示时间部分
    final logHeader = "${level.emoji} [$time][${level.upperName}]";

    _printer(_borderTop, level);
    _printer(logHeader, level);

    // 按行拆分
    final lines = message.split('\n');
    for (final rawLine in lines) {
      // 根据配置决定是否去掉缩进
      final line = preserveIndent ? rawLine : rawLine.trimLeft();

      if (line.isEmpty) {
        // 空行仍然输出一行
        // _printer("║", level);
        continue;
      }

      // 按 chunk 拆分该行
      for (var i = 0; i < line.length; i += _chunkSize) {
        final end = (i + _chunkSize < line.length)
            ? i + _chunkSize
            : line.length;
        final chunk = line.substring(i, end);
        _printer("║ $chunk", level);
      }
    }

    _printer(_borderBottom, level);
  }

  static void info(String message) => _print(_LogLevel.info, message);

  static void success(String message) => _print(_LogLevel.success, message);

  static void warning(String message) => _print(_LogLevel.warning, message);

  static void error(String message) => _print(_LogLevel.error, message);

  static void debug(String message) => _print(_LogLevel.debug, message);
}
