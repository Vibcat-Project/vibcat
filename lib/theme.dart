import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'global/color.dart';

enum ThemeType { defaultLight, defaultDark }

/// 自定义的 Theme 数据
/// 在 app 中，凡是遇到需要自己赋值一个颜色的情况，都要用这里的 ThemeStyle 的颜色数据
/// 目的为了动态切换主题方便
class ThemeStyle {
  // 默认亮色主题
  static defaultThemeLight() {
    final light = ThemeData.light();
    return light.copyWith(
      colorScheme: light.colorScheme.copyWith(
        primary: AppColor.primary,
        secondary: AppColor.primary,
      ),
      // primaryColor: AppColor.primary,
      scaffoldBackgroundColor: AppColor.scaffold,
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppColor.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          color: AppColor.black,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      // filledButtonTheme: FilledButtonThemeData(
      //   style: FilledButton.styleFrom(
      //     backgroundColor: AppColor.primary,
      //     elevation: 0,
      //   ),
      // ),
      // switchTheme: light.switchTheme.copyWith(
      //   trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
      //     if (states.contains(WidgetState.selected)) {
      //       return AppColor.primary; // 打开时轨道颜色
      //     }
      //
      //     // 关闭时回退到原始主题的轨道颜色
      //     return light.switchTheme.trackColor?.resolve(states);
      //   }),
      // ),
      iconTheme: light.iconTheme.copyWith(color: AppColor.primary),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColor.primary),
      ),
      listTileTheme: light.listTileTheme.copyWith(iconColor: AppColor.primary),
      checkboxTheme: light.checkboxTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        visualDensity: VisualDensity.compact,
      ),
      extensions: [
        const AppThemeExtension(
          container: AppColor.container,
          container2: AppColor.container2,
          container3: AppColor.container3,
          border: AppColor.border,
          divider: AppColor.divider,
          textHint: AppColor.textHint,
        ),
      ],
    );
  }

  // 默认暗色主题
  static defaultThemeDark() {
    final dark = ThemeData.dark();
    return dark.copyWith(
      primaryColor: AppColor.primary,
      primaryColorDark: AppColor.primary,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: dark.appBarTheme.copyWith(color: Colors.grey[900]),
    );
  }
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color? container;
  final Color? container2;
  final Color? container3;
  final Color? border;
  final Color? divider;
  final Color? textHint;

  const AppThemeExtension({
    this.container,
    this.container2,
    this.container3,
    this.border,
    this.divider,
    this.textHint,
  });

  @override
  AppThemeExtension copyWith({
    Color? container,
    Color? container2,
    Color? container3,
    Color? border,
    Color? divider,
    Color? textHint,
  }) {
    return AppThemeExtension(
      container: container,
      container2: container2,
      container3: container3,
      border: border,
      divider: divider,
      textHint: textHint,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      container: Color.lerp(container, other.container, t),
      container2: Color.lerp(container2, other.container2, t),
      container3: Color.lerp(container3, other.container3, t),
      border: Color.lerp(border, other.border, t),
      divider: Color.lerp(divider, other.divider, t),
      textHint: Color.lerp(textHint, other.textHint, t),
    );
  }
}
