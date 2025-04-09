import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/authentication_state_model.dart';
import '../../authentication/models/auth_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationStateModelProvider);
  }

  Future<void> login(String email, String password) async {
    await ref.read(authenticationStateModelProvider.notifier).login(email, password);
  }
}
