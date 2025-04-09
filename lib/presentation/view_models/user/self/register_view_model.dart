import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../data/domain/user.dart';
import '../../authentication/authentication_state_model.dart';
import '../../authentication/models/auth_state.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  AuthenticationState build() {
    return ref.watch(authenticationStateModelProvider);
  }

  Future<void> register(UserPayload payload, String password) async {
    await ref.read(authenticationStateModelProvider.notifier).register(payload, password);
  }
}
