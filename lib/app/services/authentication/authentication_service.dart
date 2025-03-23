import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/domain/user.dart';
import '../../../data/providers.dart';
import '../providers.dart';
import 'models/auth_state.dart';
import 'models/e_authentication_result.dart';

part 'authentication_service.g.dart';

@riverpod
class AuthenticationService extends _$AuthenticationService {
  @override
  AuthenticationState build() {
    final authenticator = ref.watch(authenticationProvider);

    if (authenticator.isAlreadyLoggedIn) {
      return AuthenticationState(
        result: EAuthenticationResult.success,
        isLoading: false,
        id: authenticator.id,
        page: null,
      );
    }
    return AuthenticationState.unknown();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final authenticator = ref.watch(authenticationProvider);
    final notificationService = ref.watch(pushNotificationsServiceProvider);

    final result = await authenticator.loginWithEmailAndPassword(email, password);
    final id = authenticator.id;

    String? token = await notificationService.getFcmToken();
    if (id != null && token != null) {
      saveUserInfo(UserPayload(id: id, fcmToken: token));
    }

    state = AuthenticationState(
      result: result,
      isLoading: false,
      id: id,
      page: "login",
    );
  }

  Future<void> logOut() async {
    final authenticator = ref.watch(authenticationProvider);
    await authenticator.logOut();
    state = AuthenticationState.unknown();
  }

  Future<void> register(UserPayload payload, String password) async {
    state = state.copyWith(isLoading: true);
    final authenticator = ref.watch(authenticationProvider);
    final notificationService = ref.watch(pushNotificationsServiceProvider);

    final result = await authenticator.registerWithEmailAndPassword(payload.email!, password);
    final id = authenticator.id;

    String? token = await notificationService.getFcmToken();
    payload = payload.copyWith(fcmToken: token);

    if (result == EAuthenticationResult.success && id != null) {
      saveUserInfo(payload);
    }

    state = AuthenticationState(
      result: result,
      isLoading: false,
      id: id,
      page: "register",
    );
  }

  Future<void> saveUserInfo(UserPayload payload) {
    final userStorage = ref.watch(userStorageProvider);
    return userStorage.saveOrUpdateUserInfo(payload);
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    state = state.copyWith(isLoading: true);
    final authenticator = ref.watch(authenticationProvider);
    final result = await authenticator.changePassword(newPassword: newPassword, oldPassword: oldPassword);
    state = state.copyWith(
      result: result,
      isLoading: false,
      page: "changePassword",
    );
  }

  Future<void> changeEmail({required String password, required String newEmail}) async {
    state = state.copyWith(isLoading: true);
    final authenticator = ref.watch(authenticationProvider);
    final result = await authenticator.changeEmail(newEmail: newEmail, password: password);
    state = state.copyWith(
      result: result,
      isLoading: false,
      page: "changeEmail",
    );
  }
}
