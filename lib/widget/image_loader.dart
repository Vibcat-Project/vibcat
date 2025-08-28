import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ImageLoader extends StatelessWidget {
  final String name;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;

  const ImageLoader({
    super.key,
    required this.name,
    this.size,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final type = name.endsWith('.svg') ? 0 : 1;

    return type == 0
        ? SvgPicture.asset(
            name,
            width: size ?? width,
            height: size ?? height,
            color: color,
          )
        : Image.asset(name, width: size ?? width, height: size ?? height);
  }
}
