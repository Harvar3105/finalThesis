import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../app/services/authentication/authentication_service.dart';
import '../../../../app/services/authentication/models/auth_state.dart';
import '../../../../data/domain/user.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationServiceProvider);
  }

  Future<void> register(UserPayload payload, String password) async {
    await ref.read(authenticationServiceProvider.notifier).register(payload, password);
  }
}
