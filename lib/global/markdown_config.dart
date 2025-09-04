import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
      H4Config(style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      H4Config(style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      PreConfig(
        theme: androidstudioTheme,
        decoration: BoxDecoration(
          color: GlobalStore.themeExt.container3,
          borderRadius: BorderRadius.circular(10),
        ),
        codeBlockTitleDecoration: BoxDecoration(
          color: GlobalStore.themeExt.codeBlock,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        codeBlockTitleCopyText: 'copy'.tr,
        language: 'text',
      ),
      CodeConfig(
        decoration: BoxDecoration(
          color: GlobalStore.themeExt.codeBlock,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6),
      ),
      TableConfig(
        border: TableBorder.all(
          color: GlobalStore.themeExt.border!,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      CheckBoxConfig(
        builder: (v) => Icon(
          v
              ? CupertinoIcons.checkmark_alt_circle_fill
              : CupertinoIcons.checkmark_alt_circle,
          size: 20,
        ),
      ),
    ],
  );

  static final generator = MarkdownGenerator(
    linesMargin: EdgeInsets.symmetric(vertical: 5),
    generators: latexGenerators,
    // 传入行内语法
    inlineSyntaxList: [InlineLatexSyntax()],
    // 传入块级语法
    blockSyntaxList: const [BlockLatexSyntax()],
  );
}
