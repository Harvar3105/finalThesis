import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/authentication_state_model.dart';
import '../../authentication/models/auth_state.dart';

part 'change_email_view_model.g.dart';

@riverpod
class ChangeEmailViewModel extends _$ChangeEmailViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationStateModelProvider);
  }

  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    await ref.read(authenticationStateModelProvider.notifier).changeEmail(
      password: password,
      newEmail: newEmail,
    );
  }
}
