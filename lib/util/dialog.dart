import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/enum/normal_dialog_button.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/route/route.dart';
import 'package:vibcat/widget/blur_bottom_sheet.dart';

import '../bean/option_bottom_sheet.dart';

class DialogUtil {
  static void showSnackBar(String message) {
    Get.snackbar(
      '',
      message,
      titleText: Container(),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      borderRadius: 20,
      backgroundColor: GlobalStore.theme.colorScheme.primary,
      colorText: AppColor.white,
      animationDuration: Duration(milliseconds: 500),
      overlayBlur: 8,
    );
  }

  static Future<int?> showOptionBottomSheet(
    List<OptionBottomSheetItem> options, {
    String? title,
  }) async {
    return await BlurBottomSheet.show(
      title ?? 'option'.tr,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map(
              (item) => Material(
                color: AppColor.transparent,
                child: ListTile(
                  title: Text(item.text),
                  onTap: () => AppRoute.back(result: item.value),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static Future<NormalDialogButton?> showNormalDialog(
    String message, {
    String? title,
    String? okText,
    String? cancelText,
  }) async {
    return await BlurBottomSheet.show(
      title ?? 'tip'.tr,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Text(message),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        AppRoute.back(result: NormalDialogButton.cancel),
                    style: FilledButton.styleFrom(
                      backgroundColor: GlobalStore.themeExt.divider,
                    ),
                    child: Text(
                      cancelText ?? 'cancel'.tr,
                      style: TextStyle(
                        color: GlobalStore.theme.textTheme.displayMedium?.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        AppRoute.back(result: NormalDialogButton.ok),
                    child: Text(okText ?? 'ok'.tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
