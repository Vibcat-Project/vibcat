import 'package:flutter/material.dart';

import '../theme.dart';

class GlobalStore {
  // 当前主题
  static ThemeData theme = ThemeStyle.defaultThemeLight();

  static AppThemeExtension get themeExt =>
      theme.extension<AppThemeExtension>()!;
}
