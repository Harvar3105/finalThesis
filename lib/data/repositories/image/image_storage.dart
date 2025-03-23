import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../repository.dart';

class ImageStorage extends Repository<FirebaseStorage> {

  ImageStorage() : super(FirebaseStorage.instance);

  Future<Map<String, String>?> uploadUserImage({
    required File file,
    required String userId,
  }) async {
    try {
      final fileBytes = await file.readAsBytes();
      final fileAsImage = img.decodeImage(fileBytes);
      if (fileAsImage == null) {
        print('Error decoding image file');
        return null;
      }

      final thumbnail = img.copyResize(fileAsImage, width: 150);
      final thumbnailData = Uint8List.fromList(img.encodeJpg(thumbnail));

      final fileName = const Uuid().v4();
      final thumbnailName = 'thumb_$fileName';

      final imagePath = "$userId/avatars/$fileName.jpg";
      final thumbnailPath = "$userId/avatars/thumbnails/$thumbnailName.jpg";

      final imageRef = base.ref(imagePath);
      await imageRef.putFile(file);
      final String imageUrl = await imageRef.getDownloadURL();

      final thumbnailRef = base.ref(thumbnailPath);
      await thumbnailRef.putData(thumbnailData);
      final String thumbnailUrl = await thumbnailRef.getDownloadURL();

      return {
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'imageName': fileName,
        'thumbnailName': thumbnailName,
      };
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> deleteUserImage({
    required String userId,
    required String avatarName,
    // required String thumbnailName,
  }) async {
    if (userId.isEmpty || avatarName.isEmpty) {
      log('Invalid user id or avatar name. Cannot delete avatar!');
      return false;
    }

    try {
      final imagePath = "$userId/avatars/$avatarName.jpg";
      // final thumbnailPath = "$userId/avatars/thumbnails/$thumbnailName.jpg";

      await base.ref(imagePath).delete();
      // await base.ref(thumbnailPath).delete();

      print('Picture deletion success.');
      return true;
    } catch (e) {
      print('Picture deletion error: $e');
      return false;
    }
  }
}
