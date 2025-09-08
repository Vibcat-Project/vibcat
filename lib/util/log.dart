import 'package:flutter/foundation.dart';
import 'dart:io';

/// 控制台颜色 ANSI 转义序列
class _LogColors {
  static const reset = '\x1B[0m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const cyan = '\x1B[36m';
}

/// 日志工具类
class LogUtil {
  static const int _chunkSize = 800;
  static const _borderTop = "╔═══════════════════════════════════════════════";
  static const _borderBottom =
      "╚═══════════════════════════════════════════════";

  // 检测是否支持颜色输出
  static bool get _supportsColor {
    // 在真实设备或支持ANSI的终端中启用颜色
    return !kIsWeb &&
        (Platform.isIOS ||
            Platform.isAndroid ||
            Platform.isMacOS ||
            Platform.isLinux) &&
        stdout.hasTerminal;
  }

  static void _print(String tag, String message, String color) {
    if (!kDebugMode) return;

    final time = DateTime.now().toIso8601String();
    final useColor = _supportsColor;

    // 根据环境决定是否使用颜色
    final colorStart = useColor ? color : '';
    final colorEnd = useColor ? _LogColors.reset : '';

    final logHeader = "$colorStart[$time][$tag]$colorEnd";

    // 分段打印，避免过长被省略
    final chunks = <String>[];
    for (var i = 0; i < message.length; i += _chunkSize) {
      final end = (i + _chunkSize < message.length)
          ? i + _chunkSize
          : message.length;
      chunks.add(message.substring(i, end));
    }

    debugPrint("$colorStart$_borderTop$colorEnd");
    debugPrint(logHeader);
    for (final chunk in chunks) {
      debugPrint("$colorStart║ $chunk$colorEnd");
    }
    debugPrint("$colorStart$_borderBottom$colorEnd");
  }

  // 简化版本 - 适用于 Android Studio
  static void _printSimple(String tag, String message, String emoji) {
    if (!kDebugMode) return;

    final time = DateTime.now().toString().substring(11, 19); // 只显示时间部分
    final logHeader = "$emoji [$time][$tag]";

    // 分段打印
    final chunks = <String>[];
    for (var i = 0; i < message.length; i += _chunkSize) {
      final end = (i + _chunkSize < message.length)
          ? i + _chunkSize
          : message.length;
      chunks.add(message.substring(i, end));
    }

    debugPrint(_borderTop);
    debugPrint(logHeader);
    for (final chunk in chunks) {
      debugPrint("║ $chunk");
    }
    debugPrint(_borderBottom);
  }

  static void info(String message) {
    if (_supportsColor) {
      _print("INFO", message, _LogColors.blue);
    } else {
      _printSimple("INFO", message, "ℹ️");
    }
  }

  static void success(String message) {
    if (_supportsColor) {
      _print("SUCCESS", message, _LogColors.green);
    } else {
      _printSimple("SUCCESS", message, "✅");
    }
  }

  static void warning(String message) {
    if (_supportsColor) {
      _print("WARNING", message, _LogColors.yellow);
    } else {
      _printSimple("WARNING", message, "⚠️");
    }
  }

  static void error(String message) {
    if (_supportsColor) {
      _print("ERROR", message, _LogColors.red);
    } else {
      _printSimple("ERROR", message, "❌");
    }
  }

  static void debug(String message) {
    if (_supportsColor) {
      _print("DEBUG", message, _LogColors.cyan);
    } else {
      _printSimple("DEBUG", message, "🔍");
    }
  }
}
