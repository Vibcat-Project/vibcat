import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/enum/ai_provider_type.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/store.dart';
import 'package:vibcat/widget/image_loader.dart';

import '../../widget/auto_sized_page_view.dart';
import 'logic.dart';
import 'state.dart';

class AddModelProviderComponent extends StatelessWidget {
  AddModelProviderComponent({super.key});

  final AddModelProviderLogic logic = Get.put(AddModelProviderLogic());
  final AddModelProviderState state = Get.find<AddModelProviderLogic>().state;

  Widget _pageHome() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text('modelProvider'.tr),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () => logic.pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: GlobalStore.themeExt.divider!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(state.currentAIProvider.value.plainName),
              ),
            ),
          ),
        ),
        if (state.currentAIProvider.value.customEndPoint == true) ...[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text('apiEndPoint'.tr),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: GlobalStore.themeExt.divider!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                isDense: true,
                errorText: state.showErrorAPIEndPointText.value
                    ? '${'pleaseInput'.tr} ${'apiEndPoint'.tr}'
                    : null,
              ),
              style: TextStyle(fontSize: 14),
              controller: logic.teAPIEndPointController,
            ),
          ),
        ],
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text('apiKey'.tr),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: GlobalStore.themeExt.divider!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              isDense: true,
              errorText: state.showErrorAPIKeyText.value
                  ? '${'pleaseInput'.tr} ${'apiKey'.tr}'
                  : null,
            ),
            style: TextStyle(fontSize: 14),
            controller: logic.teAPIKeyController,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text('modelCustomName'.tr),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: GlobalStore.themeExt.divider!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              isDense: true,
              errorText: state.showErrorCustomNameText.value
                  ? '${'pleaseInput'.tr} ${'modelCustomName'.tr}'
                  : null,
            ),
            style: TextStyle(fontSize: 14),
            controller: logic.teCustomNameController,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => logic.save(),
            child: Text('add'.tr),
          ),
        ),
      ],
    );
  }

  Widget _pageModelProviderList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AIProviderType.values.length,
      itemBuilder: (_, index) {
        final item = AIProviderType.values[index];

        return Material(
          color: AppColor.transparent,
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: BoxBorder.all(color: GlobalStore.themeExt.border!),
              ),
              child: ImageLoader.assets(name: item.icon, size: 20),
            ),
            title: Text(item.plainName),
            onTap: () {
              state.currentAIProvider.value = item;
              logic.teAPIEndPointController.text = item.endPoint;
              logic.teCustomNameController.text = item.plainName;
              logic.teAPIKeyController.text = "";

              logic.pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizedPageView(
      maxHeight: Get.height * 0.7,
      physics: NeverScrollableScrollPhysics(),
      controller: logic.pageController,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() => _pageHome()),
        ),
        _pageModelProviderList(),
      ],
    );
  }
}
