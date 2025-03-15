import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/domain/user.dart';
import '../../storage/user/user_strorage.dart';
import '../push/PushNotificationService.dart';
import 'authenticator.dart';
import 'models/e_authentication_result.dart';
import 'models/auth_state.dart';

part 'authentication_service.g.dart';

@riverpod
class AuthenticationService extends _$AuthenticationService {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserStorage();

  @override
  AuthenticationState build() {
    if (_authenticator.isAlreadyLoggedIn) {
      return AuthenticationState(
          result: EAuthenticationResult.success,
          isLoading: false,
          id: _authenticator.id,
          page: null
      );
    }
    return AuthenticationState.unknown();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator.loginWithEmailAndPassword(email, password);

    // Simulate a network request on slow environments
    //await Future.delayed(const Duration(seconds: 3));
    final id = _authenticator.id;

    String? token = await PushNotificationService().getFcmToken();
    if (id != null && token != null) {
      // If user logs in from the different account, we need to update the fcm token
      saveUserInfo(UserPayload(id: id, fcmToken: token));
    }

    state = AuthenticationState(
        result: result,
        isLoading: false,
        id: id,
        page: "login"
    );
  }

  Future<void> logOut() async {
    await _authenticator.logOut();
    state = AuthenticationState.unknown();
  }

  Future<void> register(UserPayload payload, String password) async {
    state = state.copyWith(isLoading: true);

    final result =
    await _authenticator.registerWithEmailAndPassword(payload.email!, password);

    final id = _authenticator.id;

    String? token = await PushNotificationService().getFcmToken();
    payload = payload.copyWith(fcmToken: token);

    if (result == EAuthenticationResult.success && id != null) {
      // If user creates a new account, we need to save the device FCM token
      saveUserInfo(payload);
    }

    state = AuthenticationState(
        result: result,
        isLoading: false,
        id: id,
        page: "register"
    );
  }

  Future<void> saveUserInfo(UserPayload payload) {
    return _userInfoStorage.saveOrUpdateUserInfo(payload);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, page: "changePassword");

    final result = await _authenticator.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    final id = _authenticator.id;

    String? token = await PushNotificationService().getFcmToken();

    if (result == EAuthenticationResult.success && id != null) {
      // If user creates a new account, we need to save the device FCM token
      saveUserInfo(UserPayload(id: id, fcmToken: token));
    }

    state = state.copyWith(
      isLoading: false,
      result: result,
    );
  }

  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    state = state.copyWith(isLoading: true, page: "changeEmail");

    final result = await _authenticator.changeEmail(
      password: password,
      newEmail: newEmail,
    );

    final id = _authenticator.id;

    String? token = await PushNotificationService().getFcmToken();

    if (result == EAuthenticationResult.success && id != null) {
      saveUserInfo(UserPayload(id: id, fcmToken: token));
    }

    state = state.copyWith(
      isLoading: false,
      result: result,
    );
  }
}
