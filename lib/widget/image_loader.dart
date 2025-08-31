import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

enum ImageLoaderType { assets, file, network }

class ImageLoader extends StatelessWidget {
  final ImageLoaderType type;
  final String? name;
  final File? file;
  final String? url;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final BoxFit fit;

  const ImageLoader.assets({
    super.key,
    required this.name,
    this.size,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.fit = BoxFit.contain,
  }) : type = ImageLoaderType.assets,
       file = null,
       url = null,
       assert(name != null, 'Asset name cannot be null');

  const ImageLoader.file({
    super.key,
    required this.file,
    this.size,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.fit = BoxFit.contain,
  }) : type = ImageLoaderType.file,
       name = null,
       url = null,
       assert(file != null, 'File cannot be null');

  const ImageLoader.network({
    super.key,
    required this.url,
    this.size,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.fit = BoxFit.contain,
  }) : type = ImageLoaderType.network,
       name = null,
       file = null,
       assert(url != null, 'URL cannot be null');

  double? get _width => size ?? width;

  double? get _height => size ?? height;

  bool get _isSvg {
    switch (type) {
      case ImageLoaderType.assets:
        return name?.toLowerCase().endsWith('.svg') ?? false;
      case ImageLoaderType.network:
        return url?.toLowerCase().endsWith('.svg') ?? false;
      case ImageLoaderType.file:
        return file?.path.toLowerCase().endsWith('.svg') ?? false;
    }
  }

  Widget _buildImage() {
    if (_isSvg) {
      return _buildSvgImage();
    } else {
      return _buildRasterImage();
    }
  }

  Widget _buildSvgImage() {
    switch (type) {
      case ImageLoaderType.assets:
        return SvgPicture.asset(
          name!,
          width: _width,
          height: _height,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit,
        );
      case ImageLoaderType.file:
        return SvgPicture.file(
          file!,
          width: _width,
          height: _height,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit,
        );
      case ImageLoaderType.network:
        return SvgPicture.network(
          url!,
          width: _width,
          height: _height,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit,
        );
    }
  }

  Widget _buildRasterImage() {
    Widget image;

    switch (type) {
      case ImageLoaderType.assets:
        image = Image.asset(name!, width: _width, height: _height, fit: fit);
        break;
      case ImageLoaderType.file:
        image = Image.file(file!, width: _width, height: _height, fit: fit);
        break;
      case ImageLoaderType.network:
        image = Image.network(
          url!,
          width: _width,
          height: _height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: _width,
              height: _height,
              child: const Center(
                // child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return SizedBox(
              width: _width,
              height: _height,
              // child: const Icon(Icons.error),
            );
          },
        );
        break;
    }

    // 如果是普通图片且需要颜色过滤
    if (color != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: image,
      );
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: _buildImage(),
    );
  }
}
