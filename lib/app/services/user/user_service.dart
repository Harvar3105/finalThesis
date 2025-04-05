import 'dart:io';

import 'package:final_thesis_app/app/services/image/image_service.dart';

import '../../../data/domain/user.dart';
import '../../../data/repositories/user/user_storage.dart';
import '../../typedefs/e_role.dart';
import '../../typedefs/e_sorting_order.dart';
import '../../typedefs/entity.dart';

class UserService {
  final UserStorage _userStorage;
  final ImageService _imageService;

  UserService(this._userStorage, this._imageService);

  Future<User?> getCurrentUser() async {
    return (await _userStorage.getCurrentUser())?.userFromPayload();
  }

  Stream<User?> watchCurrentUser() {
    return _userStorage.watchCurrentUser().map((payload) {
      return payload?.userFromPayload();
    });
  }

  Future<User?> getUserById(String id) async {
    return (await _userStorage.gerUserById(id))?.userFromPayload();
  }

  Future<List<User>?> getAllUsers() async {
    return (await _userStorage.getAllUsers())
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<List<User>?> getUsersByIds(Set<String> ids) async {
    return (await _userStorage.getUsersByIds(ids))
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<List<User>?> getUsersFriends(User user) async {
    return (await _userStorage.getUsersFriends(UserPayload().userToPayload(user)))
        ?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<bool> saveOrUpdateUser(User user) async {
    return await _userStorage.saveOrUpdateUserInfo(UserPayload().userToPayload(user));
  }

  Future<bool> deleteUserPicture(User user) async {
    return await _userStorage.deleteUserPicture(UserPayload().userToPayload(user));
  }

  Future<List<User>?> searchUsersByName(
      String searchingSubstring,
      int type,
      Id currentUserId,
      ERole role,
      ESortingOrder sortingOrder,
      ) async {
    return (await _userStorage.searchUsersByName(
      searchingSubstring,
      type,
      currentUserId,
      role,
      sortingOrder,
      ))?.map((user) => user.userFromPayload())
        .whereType<User>()
        .toList();
  }

  Future<User> changeNameAndPhoto({
    required User user,
    required String newFirstName,
    required String newLastName,
    File? newPhoto,
  }) async {
    Map<String, String>? imageData;

    if (newPhoto != null) {
      await deleteUserPhoto(user);
      imageData = await _imageService.uploadUserImage(file: newPhoto, user: user);
    }

    final updatedUser = UserPayload().userToPayload(user).copyWith(
      firstName: newFirstName.isEmpty ? user.firstName : newFirstName,
      lastName: newLastName.isEmpty ? user.lastName : newLastName,
      avatarUrl: imageData?['imageUrl'],
      avatarThumbnailUrl: imageData?['thumbnailUrl'],
      updatedAt: DateTime.now(),
    );

    await _userStorage.saveOrUpdateUserInfo(updatedUser);
    return updatedUser.userFromPayload()!;
  }

  Future<User> deleteUserPhoto(User user, {bool onlyStorage = false}) async {
    final isDeleted = await _imageService.deleteUserImage(user: user);
    final userPayload  = UserPayload().userToPayload(user);
    if (isDeleted && !onlyStorage) {
      await _userStorage.deleteUserPicture(userPayload);
    }
    return userPayload.copyWith(avatarUrl: null, avatarThumbnailUrl: null).userFromPayload()!;
  }
}