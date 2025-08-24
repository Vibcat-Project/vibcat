import 'package:flutter/material.dart';

class AppUtil {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
