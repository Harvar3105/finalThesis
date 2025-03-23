import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../../../configurations/image_constants.dart';


part 'image_storage.g.dart';

@riverpod
class ImageUpload extends _$ImageUpload {
  @override
  bool build() => false;

  set isLoading(bool value) => state = value;

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Map<String, String>?> uploadUserImageToStorage({
    required File file,
    required String userId,
  }) async {
    try {
      final fileAsImage = img.decodeImage(file.readAsBytesSync());
      if (fileAsImage == null) {
        print('Error decoding image file');
        return null;
      }

      final thumbnail = img.copyResize(
        fileAsImage,
        width: ImageConstants.imageThumbnailWidth,
      );
      final thumbnailData = img.encodeJpg(thumbnail);
      Uint8List thumbnailUint8List = Uint8List.fromList(thumbnailData);

      final fileName = const Uuid().v4();
      final thumbnailName = 'thumb_$fileName';

      final imagePath = "$userId/avatars/$fileName.jpg";
      final thumbnailPath = "$userId/avatars/thumbnails/$thumbnailName.jpg";

      final UploadTask imageUploadTask = storage.ref(imagePath).putFile(file);
      final TaskSnapshot imageSnapshot = await imageUploadTask;
      final String imageUrl = await imageSnapshot.ref.getDownloadURL();

      final UploadTask thumbnailUploadTask = storage.ref(thumbnailPath).putData(thumbnailUint8List);
      final TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
      final String thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

      return {
        'imageUrl': imageUrl,
        'thumbnailUrl': thumbnailUrl,
        'imageName': fileName,
        'thumbnailName': thumbnailName,
      };
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      return null;
    }
  }

  Future<bool> deleteUserImageFromFirebase({
    required String userId,
    required String imageName,
    required String thumbnailName,
  }) async {
    try {
      final imagePath = "$userId/avatars/$imageName.jpg";
      final thumbnailPath = "$userId/avatars/thumbnails/$thumbnailName.jpg";

      await storage.ref(imagePath).delete();
      await storage.ref(thumbnailPath).delete();

      print('Picture deletion success.');
      return true;
    } catch (e) {
      print('Picture deletion error: $e');
      return false;
    }
  }
}
