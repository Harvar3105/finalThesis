import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/authentication/authentication_service.dart';
import '../../../../app/services/authentication/models/auth_state.dart';

part 'change_password_view_model.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationServiceProvider);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await ref.read(authenticationServiceProvider.notifier).changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
