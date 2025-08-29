import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerUtil {
  static Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.xFile.path);
    }

    return null;
  }
}
