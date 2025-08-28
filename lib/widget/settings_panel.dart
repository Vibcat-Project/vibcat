import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  final List<SettingsPanelItem> items;
  final Text? title;
  final double? titleItemSpacing;
  final BorderRadiusGeometry borderRadius;
  final Color? backgroundColor;
  final Widget divider;

  SettingsPanel({
    super.key,
    required this.items,
    this.title,
    this.titleItemSpacing,
    BorderRadiusGeometry? borderRadius,
    this.backgroundColor,
    Widget? divider,
  }) : borderRadius = borderRadius ?? BorderRadius.circular(20),
       divider = divider ?? Divider(height: 1, thickness: 0.1, indent: 16);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.data ?? '',
            style: TextStyle(fontWeight: FontWeight.bold).merge(title!.style),
          ),
          SizedBox(height: titleItemSpacing ?? 10),
        ],
        ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: item.leading,
                    trailing: item.trailing,
                    visualDensity: VisualDensity.compact,
                    title: item.text,
                    onTap: item.onTap,
                  ),
                );
              },
              separatorBuilder: (_, _) => divider,
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsPanelItem {
  final Widget? leading;
  final Widget? text;
  final Widget? trailing;
  final void Function()? onTap;

  SettingsPanelItem({this.leading, this.text, this.trailing, this.onTap});
}
