import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';

class FileUtil {
  /// File 转 Base64
  static Future<String> fileToBase64(File file) async {
    final fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  /// Base64 转 Uint8List（可直接用于 Image.memory）
  static Uint8List base64ToBytes(String base64Str) {
    return base64Decode(base64Str);
  }

  /// Base64 转 File
  static Future<File> base64ToFile(String base64Str, String filePath) async {
    final bytes = base64Decode(base64Str);
    final file = File(filePath);
    return await file.writeAsBytes(bytes);
  }

  /// 带 dataUri 前缀的 Base64（用于 img 标签或 Image.memory）
  static Future<String> fileToBase64DataUri(
    File file, {
    String mimeType = "image/png",
  }) async {
    String base64Str = await fileToBase64(file);
    return "data:$mimeType;base64,$base64Str";
  }

  /// 获取文件 MIME type (异步)
  static Future<String> getMimeType(File file, {bool byHeader = true}) async {
    try {
      List<int>? headerBytes;

      if (byHeader) {
        // 读取文件头前 12 字节，如果文件比 12 小也没问题。但如果文件很小，first 可能只返回不足 12 个字节。
        final stream = file.openRead(0, 12);
        final bytes = await stream.first;
        headerBytes = bytes;
      }

      final mimeType = lookupMimeType(file.path, headerBytes: headerBytes);

      return mimeType ?? 'application/octet-stream';
    } catch (e) {
      return 'application/octet-stream';
    }
  }

  /// 同步获取文件 MIME type
  static String getMimeTypeSync(File file, {bool byHeader = false}) {
    try {
      List<int>? headerBytes;

      if (byHeader) {
        final raf = file.openSync();
        try {
          headerBytes = raf.readSync(12);
        } finally {
          raf.closeSync();
        }
      }

      final mimeType = lookupMimeType(file.path, headerBytes: headerBytes);

      return mimeType ?? 'application/octet-stream';
    } catch (e) {
      return 'application/octet-stream';
    }
  }
}
