import 'dart:io';

import 'package:image_picker/image_picker.dart';


extension ToFile on Future<XFile?> {
  Future<File?> toFile() => then(
        (xFile) => xFile
        ?.path, // Get the file path from the XFile, or null if XFile is null.
  ).then(
        (filePath) => filePath != null
        ? File(filePath)
        : null, // Create a File object if the path is not null, otherwise return null.
  );
}
