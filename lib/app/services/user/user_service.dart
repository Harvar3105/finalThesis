import 'dart:io';

import 'package:final_thesis_app/app/models/file/custom_image_file.dart';
import 'package:final_thesis_app/app/services/image/image_service.dart';

import '../../../data/domain/user.dart';
import '../../../data/repositories/user/user_storage.dart';
import '../../typedefs/e_role.dart';
import '../../typedefs/e_sorting_order.dart';
import '../../typedefs/entity.dart';

class UserService {
  final UserStorage _userStorage;
  final ImageService _imageService;

  User? _currentUser;

  UserService(this._userStorage, this._imageService);

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    _currentUser = (await _userStorage.getCurrentUser())?.userFromPayload();
    return _currentUser;
  }

  Stream<User?> watchCurrentUser() async* {
    await for (final payload in _userStorage.watchCurrentUser()) {
      try {
        final user = payload?.userFromPayload();
        _currentUser = user;
        yield user;
      } catch (e, st) {
        yield null;
      }
    }
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
    final result = await _userStorage.saveOrUpdateUserInfo(UserPayload().userToPayload(user));
    if (result && _currentUser != null && _currentUser!.id == user.id) {
      _currentUser = user;
    }
    return result;
  }

  Future<bool> deleteUserPicture(User user) async {
    final result = await _userStorage.deleteUserPicture(UserPayload().userToPayload(user));
    if (result && _currentUser != null && _currentUser!.id == user.id) {
      _currentUser = user;
    }
    return result;
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
    CustomImageFile? newPhoto,
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
    if (_currentUser != null && _currentUser!.id == user.id) {
      _currentUser = updatedUser.userFromPayload()!;
    }
    return updatedUser.userFromPayload()!;
  }

  Future<User> deleteUserPhoto(User user, {bool onlyStorage = false}) async {
    final isDeleted = await _imageService.deleteUserImage(user: user);
    final userPayload  = UserPayload().userToPayload(user);
    if (isDeleted && !onlyStorage) {
      await _userStorage.deleteUserPicture(userPayload);
    }
    final result = userPayload.copyWith(avatarUrl: null, avatarThumbnailUrl: null).userFromPayload()!;
    if (_currentUser != null && _currentUser!.id == result.id) {
      _currentUser = result;
    }
    return result;
  }
}