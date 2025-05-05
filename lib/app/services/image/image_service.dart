
import 'package:final_thesis_app/app/models/file/custom_image_file.dart';

import '../../../data/domain/user.dart';
import '../../../data/repositories/image/image_storage.dart';

class ImageService {
  final ImageStorage _imageUpload;

  ImageService(this._imageUpload);

  Future<Map<String, String>?> uploadUserImage({
    required CustomImageFile file,
    required User user,
  }) async {
    return await _imageUpload.uploadUserImage(file: file, user: UserPayload().userToPayload(user));
  }

  Future<bool> deleteUserImage({
    required User user,
  }) async {
    return await _imageUpload.deleteUserImage(
      user: UserPayload().userToPayload(user)
    );
  }
}
