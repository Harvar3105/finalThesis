import 'package:final_thesis_app/configurations/app_options.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

// Process is async because might take some time
Future<Uint8List> getImageThumbnail(img.Image image) async {
  int width = image.width;
  int height = image.height;
  int quality = 100;

  Uint8List result;

  while (true) {
    final resized = img.copyResize(image, width: width, height: height);
    final compressed = img.encodeJpg(resized, quality: quality);
    result = Uint8List.fromList(compressed);

    if (result.lengthInBytes <= AppOptions.maxThumbnailSize) {
      break;
    }

    width = (width * 0.9).floor();
    height = (height * 0.9).floor();
    quality = (quality * 0.9).floor();

    if (width < 32 || height < 32 || quality < 10) {
      break;
    }
  }

  return result;
}
