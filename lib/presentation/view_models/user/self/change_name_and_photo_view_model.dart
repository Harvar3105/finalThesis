import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'change_name_and_photo_view_model.g.dart';

@riverpod
class ChangeNamePhotoViewModel extends _$ChangeNamePhotoViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> changeNameAndPhoto({
    required User user,
    required String newFirstName,
    File? newPhoto,
  }) async {
    final userService = ref.read(userServiceProvider);
    final imageService = ref.read(imageServiceProvider);

    Map<String, String>? imageData;

    if (newPhoto != null) {
      await deleteProfilePhoto(user, onlyStorage: true);
      imageData = await imageService.uploadUserImage(
        file: newPhoto,
        userId: user.id!,
      );
    }

    final updatedUser = User(
      id: user.id,
      firstName: newFirstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      aboutMe: user.aboutMe,
      avatarUrl: imageData?['imageUrl'] ?? user.avatarUrl,
      friends: user.friends,
      friendRequests: user.friendRequests,
      sentFriendRequests: user.sentFriendRequests,
      blockedUsers: user.blockedUsers,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: DateTime.now(),
    );

    await userService.saveOrUpdateUser(updatedUser);
  }

  Future<void> deleteProfilePhoto(User user, {bool onlyStorage = false}) async {
    final userService = ref.read(userServiceProvider);
    final imageService = ref.read(imageServiceProvider);

    final isDeleted = await imageService.deleteUserImage(userId: user.id ?? '', avatarName: user.avatarName ?? '');
    if (isDeleted && !onlyStorage) {
      await userService.deleteUserPicture(user);
    }
  }
}
