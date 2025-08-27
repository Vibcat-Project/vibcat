import 'package:get/get.dart';
import 'package:vibcat/data/bean/ai_model.dart';

class AddModelsState {
  final RxnDouble height = RxnDouble(100);
  final selectedModelList = <AIModel>[].obs;
  final modelList = <AIModel>[].obs;

  AddModelsState() {
    ///Initialize variables
  }
}
