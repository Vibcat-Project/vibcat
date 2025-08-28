import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';

import '../../global/icons.dart';
import '../../global/store.dart';
import 'logic.dart';
import 'state.dart';

class SettingsComponent extends StatelessWidget {
  SettingsComponent({super.key});

  final SettingsLogic logic = Get.put(SettingsLogic());
  final SettingsState state = Get.find<SettingsLogic>().state;

  Widget _listItem(IconData icon, String title) {
    return Material(
      color: AppColor.transparent,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title.tr, style: TextStyle(fontSize: 16)),
        trailing: Icon(
          AppIcon.arrowRight,
          color: GlobalStore.themeExt.textHint,
          fontWeight: FontWeight.bold,
        ),
        onTap: () => logic.onSettingsItemSelected(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _listItem(Icons.ac_unit, 'modelSettings'),
        _listItem(Icons.ac_unit, 'onlineSearch'),
        _listItem(Icons.ac_unit, 'chatSettings'),
        _listItem(Icons.ac_unit, 'otherSettings'),
        Obx(
          () => ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text('hapticFeedback'.tr, style: TextStyle(fontSize: 16)),
            trailing: Switch(
              value: state.hapticFeedbackEnabled.value,
              onChanged: logic.onHapticFeedbackChanged,
            ),
          ),
        ),
      ],
    );
  }
}
