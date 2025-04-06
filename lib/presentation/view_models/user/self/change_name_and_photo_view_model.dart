import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'change_name_and_photo_view_model.g.dart';

@riverpod
class ChangeNamePhotoViewModel extends _$ChangeNamePhotoViewModel {
  @override
  FutureOr<void> build() {}

  Future<User> changeNameAndPhoto({
    required User user,
    required String newFirstName,
    required String newLastName,
    File? newPhoto,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userService = ref.read(userServiceProvider);
      final updatedUser = await userService.changeNameAndPhoto(
        user: user,
        newFirstName: newFirstName,
        newLastName: newLastName,
        newPhoto: newPhoto,
      );
      state = AsyncValue.data(updatedUser);
      return updatedUser;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return user;
    }
  }

  Future<void> deleteProfilePhoto(User user, {bool onlyStorage = false}) async {
    state = const AsyncValue.loading();
    try {
      final userService = ref.read(userServiceProvider);
      final updatedUser = await userService.deleteUserPhoto(user, onlyStorage: onlyStorage);
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
