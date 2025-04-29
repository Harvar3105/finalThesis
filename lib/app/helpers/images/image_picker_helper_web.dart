import 'package:final_thesis_app/app/helpers/images/to_file.dart';
import 'package:final_thesis_app/app/models/file/custom_image_file.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerWebHelper {
  static Future<CustomImageFile?> pickImageFromGallery() {
    return ImagePickerWeb.getImageAsBytes().toFile();
  }

  // static Future<List<File>?> pickMultipleImagesFromGallery() async {
  //   return await ImagePickerWeb.getMultiImagesAsFile();
  // }
}