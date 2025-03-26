import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/authentication/authentication_service.dart';
import '../../../../app/services/authentication/models/auth_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationServiceProvider);
  }

  Future<void> login(String email, String password) async {
    await ref.read(authenticationServiceProvider.notifier).login(email, password);
  }
}
