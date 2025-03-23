import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/authentication/authentication_service.dart';
import '../../../../app/services/authentication/models/auth_state.dart';

part 'change_email_view_model.g.dart';

@riverpod
class ChangeEmailViewModel extends _$ChangeEmailViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationServiceProvider);
  }

  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    await ref.read(authenticationServiceProvider.notifier).changeEmail(
      password: password,
      newEmail: newEmail,
    );
  }
}
