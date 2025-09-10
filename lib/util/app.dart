import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppUtil {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 等待键盘完全关闭后再执行回调
  static Future<void> waitKeyboardClosed({
    Duration checkInterval = const Duration(milliseconds: 100),
  }) async {
    while (Get.mediaQuery.viewInsets.bottom > 0) {
      // 键盘还没关，等一会儿再检测
      await Future.delayed(checkInterval);
    }
    // 键盘彻底关闭
  }

  static Future<void> copyToClipboard(String? content) async {
    await Clipboard.setData(ClipboardData(text: content ?? ''));
  }
}
