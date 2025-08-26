import 'package:get/get.dart';
import 'package:vibcat/data/schema/conversation.dart';

class DrawerState {
  final list = <Conversation>[].obs;
  final currentIndex = (-1).obs;

  DrawerState() {
    ///Initialize variables
  }
}
