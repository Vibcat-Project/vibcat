import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibcat/global/color.dart';
import 'package:vibcat/global/lottie.dart';
import 'package:vibcat/widget/error_retry.dart';

import 'logic.dart';
import 'state.dart';

class AddModelsComponent extends StatelessWidget {
  AddModelsComponent({super.key});

  final AddModelsLogic logic = Get.find<AddModelsLogic>();
  final AddModelsState state = Get.find<AddModelsLogic>().state;

  Widget _loading() => Padding(
    key: logic.loadingKey,
    padding: EdgeInsets.only(top: 50),
    child: ErrorRetry(loading: AppLottie.loadingWidget(), error: Container()),
  );

  Widget _item(int index) {
    final item = state.modelList[index];
    final checked = state.selectedModelList.any((e) => e.id == item.id);

    return Material(
      color: AppColor.transparent,
      child: ListTile(
        title: Text(item.id),
        onTap: () => logic.select(item, checked),
        trailing: Checkbox(
          value: checked,
          onChanged: (_) => logic.select(item, checked),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.modelList.length,
            itemBuilder: (_, index) => _item(index),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => logic.save(),
                  child: Text('ok'.tr),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return logic.obx(
      (_) => Obx(
        () => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: state.height.value,
          curve: Curves.easeInOut,
          child: _body(),
        ),
      ),
      onLoading: _loading(),
    );
  }
}
