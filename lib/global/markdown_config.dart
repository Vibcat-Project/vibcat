import 'package:flutter/widgets.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/themes/androidstudio.dart';
import 'package:vibcat/global/store.dart';

class MarkdownConfigs {
  static final config = MarkdownConfig.defaultConfig.copy(
    configs: [
      HrConfig(height: 0),
      H1Config(style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      H2Config(style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      H3Config(style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      H4Config(style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      PreConfig(theme: androidstudioTheme, decoration: BoxDecoration(
        color: GlobalStore.themeExt.container3,
        borderRadius: BorderRadius.circular(10)
      ))
    ],
  );

  static final generator = MarkdownGenerator(linesMargin: EdgeInsets.symmetric(vertical: 5));
}
