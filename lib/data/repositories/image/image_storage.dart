import 'dart:developer';
import 'dart:io';

import 'package:final_thesis_app/data/domain/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../repository.dart';

class ImageStorage extends Repository<FirebaseStorage> {

  ImageStorage() : super(FirebaseStorage.instance);

  Future<Map<String, String>?> uploadUserImage({
    required File file,
    required UserPayload user,
  }) async {
    try {
      final fileBytes = await file.readAsBytes();
      final fileAsImage = img.decodeImage(fileBytes);
      if (fileAsImage == null) {
        log('Error decoding image file');
        return null;
      }

      final thumbnail = img.copyResize(fileAsImage, width: 100);
      final thumbnailData = Uint8List.fromList(img.encodeJpg(thumbnail));

      final fileName = const Uuid().v4();
      final thumbnailName = 'thumb_$fileName';

      final userId = user.id!;
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
      log('Error uploading image: $e');
      return null;
    }
  }

  Future<bool> deleteUserImage({
    required UserPayload user,
  }) async {
    //TODO: Add avatar thumbnail deletion
    if (user.id == null || user.avatarUrl == null) {
      log('Invalid user id or avatarUrl. Cannot delete avatar! Id: ${user.id}, avatarUrl: ${user.avatarUrl}');
      return false;
    }

    try {
      final imagePath = Uri.parse(user.avatarUrl!).pathSegments.last;
      await base.ref(imagePath).delete();

      if (user.avatarThumbnailUrl != null) {
        final thumbnailPath = Uri.parse(user.avatarThumbnailUrl!).pathSegments.last;
        await base.ref(thumbnailPath).delete();
      }

      log('Picture deletion success.');
      return true;
    } catch (e) {
      log('Picture deletion error: $e');
      return false;
    }
  }
}
