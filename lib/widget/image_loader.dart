import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

enum ImageLoaderType { assets, file, network }

class ImageLoader extends StatelessWidget {
  final ImageLoaderType type;

  String? _name;
  File? _file;

  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final BoxFit? fit;

  ImageLoader.assets({
    super.key,
    required String name,
    this.size,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.fit,
  }) : type = ImageLoaderType.assets,
       _name = name;

  ImageLoader.file({
    super.key,
    required File file,
    this.size,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.fit,
  }) : type = ImageLoaderType.file,
       _file = file;

  Widget _buildImage() {
    switch (type) {
      case ImageLoaderType.assets:
        return _name!.endsWith('.svg')
            ? SvgPicture.asset(
                _name!,
                width: size ?? width,
                height: size ?? height,
                color: color,
                fit: fit ?? BoxFit.contain,
              )
            : Image.asset(
                _name!,
                width: size ?? width,
                height: size ?? height,
                fit: fit,
              );
      case ImageLoaderType.file:
        return Image.file(
          _file!,
          width: size ?? width,
          height: size ?? height,
          fit: fit,
        );
      default:
        throw Exception('Invalid type.');
    }
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius ?? 0),
    child: _buildImage(),
  );
}
