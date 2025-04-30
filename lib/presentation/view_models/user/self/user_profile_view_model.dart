
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'user_profile_view_model.g.dart';

@riverpod
class UserProfileViewModel extends _$UserProfileViewModel {
  late final User? currentUser;
  late bool isCurrentUser;

  @override
  FutureOr<User?> build({User? selectedUser}) async {
    log("${selectedUser?.firstName} ${selectedUser?.lastName}");
    final userService = ref.watch(userServiceProvider);
    currentUser = await userService.getCurrentUser();

    if (selectedUser != null) {
      isCurrentUser = false;
      return selectedUser;
    } else {
      isCurrentUser = true;
      if (currentUser != null) {
        return currentUser!;
      } else {
        state = AsyncValue.error("Current user is not defined", StackTrace.current);
      }
    }
    return null;
  }
}