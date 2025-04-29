import 'package:final_thesis_app/app/helpers/images/to_file.dart';
import 'package:final_thesis_app/app/models/file/custom_image_file.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<CustomImageFile?> pickImageFromGallery() =>
      _imagePicker.pickImage(source: ImageSource.gallery).toFile();

  // static Future<CustomImageFile?> pickImageFromCamera() =>
  //     _imagePicker.pickImage(source: ImageSource.camera).toFile();

  // static Future<List<CustomImageFile>?> pickMultipleImagesFromGallery() async {
  //   final List<XFile> images = await _imagePicker.pickMultiImage();
  //
  //   return images.map((image) => File(image.path)).toList();
  //     return null;
  // }
}

