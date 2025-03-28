import 'dart:io';

import 'package:final_thesis_app/app/helpers/to_file.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImageFromGallery() =>
      _imagePicker.pickImage(source: ImageSource.gallery).toFile();

  static Future<File?> pickImageFromCamera() =>
      _imagePicker.pickImage(source: ImageSource.camera).toFile();

  static Future<List<File>?> pickMultipleImagesFromGallery() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();

    return images.map((image) => File(image.path)).toList();
      return null;
  }
}

