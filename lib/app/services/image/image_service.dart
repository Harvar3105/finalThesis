import 'dart:io';

import '../../../data/repositories/image/image_storage.dart';

class ImageService {
  final ImageStorage _imageUpload;

  ImageService(this._imageUpload);

  Future<Map<String, String>?> uploadUserImage({
    required File file,
    required String userId,
  }) async {
    return await _imageUpload.uploadUserImage(file: file, userId: userId);
  }

  Future<bool> deleteUserImage({
    required String userId,
    required String avatarName,
    // required String thumbnailName,
  }) async {
    return await _imageUpload.deleteUserImage(
      userId: userId,
      avatarName: avatarName,
      // thumbnailName: thumbnailName,
    );
  }
}
