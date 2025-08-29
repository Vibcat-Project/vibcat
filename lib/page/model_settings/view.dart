import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/util/number.dart';

import '../../global/icons.dart';
import '../../widget/image_loader.dart';
import 'logic.dart';
import 'state.dart';

class ModelSettingsPage extends StatelessWidget {
  ModelSettingsPage({super.key});

  final ModelSettingsLogic logic = Get.put(ModelSettingsLogic());
  final ModelSettingsState state = Get.find<ModelSettingsLogic>().state;

  AppBar _appBar() {
    return AppBar(
      title: Text('modelSettings'.tr),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () => logic.showAddModelSheet(),
            icon: Icon(AppIcon.add, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _slidableActionPane(
    Color bgColor,
    IconData icon, {
    Color? iconColor,
    Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
      itemCount: state.aiModelConfigList.length,
      itemBuilder: (_, index) {
        final item = state.aiModelConfigList[index];

        return Slidable(
          key: ValueKey(item.id),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              _slidableActionPane(
                GlobalStore.themeExt.border!,
                AppIcon.edit,
                onTap: () => logic.edit(index),
              ),
              _slidableActionPane(
                AppColor.red,
                AppIcon.delete,
                iconColor: AppColor.white,
                onTap: () => logic.delete(index),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => logic.showModelList(index),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GlobalStore.themeExt.container,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: BoxBorder.all(
                            color: GlobalStore.themeExt.border!,
                          ),
                        ),
                        child: ImageLoader.assets(
                          name: item.provider.icon,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.customName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: GlobalStore.themeExt.divider,
                        ),
                        child: Text(
                          item.provider.plainName,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 34),
                    child: Text(
                      '${'apiEndPoint'.tr}: ${item.endPoint}',
                      style: TextStyle(
                        color: GlobalStore.theme.hintColor,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 34),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: item.hasModels
                          ? GlobalStore.themeExt.divider
                          : AppColor.orangeAccent,
                    ),
                    child: Text(
                      item.hasModels ? '模型数量：${item.models!.length}' : '未选择模型',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 34),
                          child: Text(
                            '${'inputToken'.tr}: ${NumberUtil.formatNumber(item.tokenInput)}',
                            style: TextStyle(
                              color: GlobalStore.theme.hintColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${'outputToken'.tr}: ${NumberUtil.formatNumber(item.tokenOutput)}',
                          style: TextStyle(
                            color: GlobalStore.theme.hintColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: Obx(() => _body()));
  }
}
