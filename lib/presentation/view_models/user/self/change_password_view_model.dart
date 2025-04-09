import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/authentication_state_model.dart';
import '../../authentication/models/auth_state.dart';

part 'change_password_view_model.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationStateModelProvider);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await ref.read(authenticationStateModelProvider.notifier).changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
