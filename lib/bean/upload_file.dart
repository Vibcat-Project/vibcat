import 'dart:io';

import 'package:vibcat/util/file.dart';

sealed class UploadFileWrap {
  /// 实际文件对象
  File get file;

  /// 文件名
  String get name;

  String get mimeType;

  /// 复制功能：子类必须实现
  UploadFileWrap copyWith({File? file, String? name, String? mimeType});

  /// 深拷贝：生成一份新的对象
  UploadFileWrap deepCopy();
}

final class UploadImage extends UploadFileWrap {
  @override
  final File file;

  @override
  final String name;

  @override
  final String mimeType;

  /// 直接传 File
  UploadImage(this.file, {String? name, String? mimeType})
    : name = name ?? file.uri.pathSegments.last,
      mimeType = mimeType ?? FileUtil.getMimeTypeSync(file);

  /// 传 path
  UploadImage.fromPath(String path, {String? name, String? mimeType})
    : file = File(path),
      name = name ?? File(path).uri.pathSegments.last,
      mimeType = mimeType ?? FileUtil.getMimeTypeSync(File(path));

  @override
  UploadImage copyWith({File? file, String? name, String? mimeType}) {
    final newFile = file ?? this.file;
    return UploadImage(
      newFile,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  UploadImage deepCopy() {
    return UploadImage(
      File(file.path), // 新建一个 File 实例（路径相同）
      name: name,
      mimeType: mimeType,
    );
  }
}

final class UploadFile extends UploadFileWrap {
  @override
  final File file;

  @override
  final String name;

  @override
  final String mimeType;

  UploadFile(this.file, {String? name, String? mimeType})
    : name = name ?? file.uri.pathSegments.last,
      mimeType = mimeType ?? FileUtil.getMimeTypeSync(file);

  UploadFile.fromPath(String path, {String? name, String? mimeType})
    : file = File(path),
      name = name ?? File(path).uri.pathSegments.last,
      mimeType = mimeType ?? FileUtil.getMimeTypeSync(File(path));

  @override
  UploadFile copyWith({File? file, String? name, String? mimeType}) {
    final newFile = file ?? this.file;
    return UploadFile(
      newFile,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  UploadFile deepCopy() {
    return UploadFile(
      File(file.path), // 新建一个 File 实例（路径相同）
      name: name,
      mimeType: mimeType,
    );
  }
}

final class UploadLink extends UploadFileWrap {
  // 这里不用 final，因为需要动态变更值
  @override
  File file;

  @override
  final String name;

  @override
  final String mimeType;

  static const _defaultMimeType = 'text/plain';

  UploadLink(String text, {String? name, String? mimeType})
    : file = File(text),
      name = name ?? '',
      mimeType = mimeType ?? _defaultMimeType;

  @override
  UploadLink copyWith({File? file, String? name, String? mimeType}) {
    final newFile = file ?? this.file;
    return UploadLink(
      newFile.path,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  UploadLink deepCopy() {
    return UploadLink(
      file.path, // 新建一个 File 实例（路径相同）
      name: name,
      mimeType: mimeType,
    );
  }
}

final class UploadWebSearch extends UploadFileWrap {
  @override
  final File file;

  @override
  final String name;

  @override
  final String mimeType;

  static const _defaultMimeType = 'text/plain';

  UploadWebSearch(String text, {String? name, String? mimeType})
    : file = File(text),
      name = name ?? '',
      mimeType = mimeType ?? _defaultMimeType;

  @override
  UploadWebSearch copyWith({File? file, String? name, String? mimeType}) {
    final newFile = file ?? this.file;
    return UploadWebSearch(
      newFile.path,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  UploadWebSearch deepCopy() {
    return UploadWebSearch(
      file.path, // 新建一个 File 实例（路径相同）
      name: name,
      mimeType: mimeType,
    );
  }
}
