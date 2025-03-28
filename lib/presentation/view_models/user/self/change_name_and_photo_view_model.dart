import 'dart:developer';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'change_name_and_photo_view_model.g.dart';

@riverpod
class ChangeNamePhotoViewModel extends _$ChangeNamePhotoViewModel {
  @override
  FutureOr<void> build() {}

  Future<User?> changeNameAndPhoto({
    required User user,
    required String newFirstName,
    required String newLastName,
    File? newPhoto,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userService = ref.read(userServiceProvider);
      final imageService = ref.read(imageServiceProvider);

      Map<String, String>? imageData;

      if (newPhoto != null) {
        await deleteProfilePhoto(user, onlyStorage: true);
        state = const AsyncValue.loading(); // Process above is heavy enough to reset state. Set loading again
        imageData = await imageService.uploadUserImage(
          file: newPhoto,
          user: user,
        );
      }

      final updatedUser = User(
        id: user.id,
        firstName: newFirstName.isEmpty ? user.firstName : newFirstName,
        lastName: newLastName.isEmpty ? user.lastName : newLastName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        aboutMe: user.aboutMe,
        avatarUrl: imageData?['imageUrl'],
        avatarThumbnailUrl: imageData? ['thumbnailUrl'],
        friends: user.friends,
        friendRequests: user.friendRequests,
        sentFriendRequests: user.sentFriendRequests,
        blockedUsers: user.blockedUsers,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: DateTime.now(),
      );
      await userService.saveOrUpdateUser(updatedUser);
      state = AsyncValue.data(updatedUser);
      return updatedUser;
    } catch(error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  Future<User?> deleteProfilePhoto(User user, {bool onlyStorage = false}) async {
    state = const AsyncValue.loading();
    final userService = ref.read(userServiceProvider);
    final imageService = ref.read(imageServiceProvider);

    final isDeleted = await imageService.deleteUserImage(user: user);
    if (isDeleted && !onlyStorage) {
      await userService.deleteUserPicture(user);
    }
    user.avatarUrl = null;
    state = AsyncValue.data(user);
    return user;
  }
}
