import 'dart:developer';
import 'dart:typed_data';

import 'package:final_thesis_app/app/models/file/custom_image_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';



extension ToCustomFile on Future<XFile?> {
  Future<CustomImageFile?> toFile() => then(
      (file) async {
        try{
          final name = file?.name ?? Uuid().v4();
          final path = file?.path;
          final data = await file?.readAsBytes();
          if (data == null) {
            log("Broken File. No data!");
            return null;
          }
          return CustomImageFile(name: name, data: data, path: path);
        } catch (e){
          log("Error while parsing xFile: $e");
          return null;
        }
      }
  );
}

extension ToCustomFileWeb on Future<Uint8List?> {
  Future<CustomImageFile?> toFile() => then(
      (data) {
        try{
          if (data == null) {
            log("Broken File. No data!");
            return null;
          }
          final name = Uuid().v4();
          return CustomImageFile(name: name, data: data);
        } catch (e){
          log("Error while parsing xFile: $e");
          return null;
        }
      }
  );
}
