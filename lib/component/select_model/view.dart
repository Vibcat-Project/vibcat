import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';

import '../../global/store.dart';
import '../../widget/image_loader.dart';
import 'logic.dart';
import 'state.dart';

class SelectModelComponent extends StatelessWidget {
  SelectModelComponent({super.key});

  final SelectModelLogic logic = Get.put(SelectModelLogic());
  final SelectModelState state = Get.find<SelectModelLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.aiModelConfigList.length,
        itemBuilder: (_, index) {
          final item = state.aiModelConfigList[index];

          return Column(
            children: [
              // 一级标题
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: GlobalStore.themeExt.border!),
                  ),
                  child: ImageLoader.assets(name: item.provider.icon, size: 20),
                ),
                title: Text(item.customName),
              ),
              // 二级子项 - 可单选点击
              ...item.models!.map(
                (model) => Material(
                  color: AppColor.transparent,
                  child: ListTile(
                    visualDensity: VisualDensity.comfortable,
                    leading: SizedBox(width: 36),
                    title: Text(model.id),
                    onTap: () => logic.selectModel(item, model),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
