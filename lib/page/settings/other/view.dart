import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';

import '../../../global/store.dart';
import 'logic.dart';
import 'state.dart';

class Item {
  final String text;
  final Color? textColor;
  final void Function()? onTap;

  Item({required this.text, this.textColor, this.onTap});
}

class OtherSettingsPage extends StatelessWidget {
  OtherSettingsPage({super.key});

  final OtherSettingsLogic logic = Get.put(OtherSettingsLogic());
  final OtherSettingsState state = Get.find<OtherSettingsLogic>().state;

  AppBar _appBar() => AppBar(title: Text('otherSettings'.tr));

  Widget _group(String title, List<Item> items) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: GlobalStore.themeExt.container,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return Material(
                color: AppColor.transparent,
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    item.text,
                    style: TextStyle(color: item.textColor),
                  ),
                  onTap: item.onTap,
                ),
              );
            },
            separatorBuilder: (_, _) =>
                Divider(height: 1, thickness: 0.1, indent: 16),
          ),
        ),
      ),
    ],
  );

  Widget _body() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
      children: [
        SizedBox(height: 20),
        _group("数据管理", [
          Item(text: '导出所有对话', onTap: () => logic.exportAllData()),
          Item(
            text: '删除所有对话',
            textColor: AppColor.red,
            onTap: () => logic.deleteAllData(),
          ),
        ]),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }
}
