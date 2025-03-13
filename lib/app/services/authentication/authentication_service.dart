import 'package:final_thesis_app/app/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
          userId: _authenticator.userId,
          page: null
      );
    }
    return AuthenticationState.unknown();
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator.loginWithEmailAndPassword(email, password);

    // Simulate a network request on slow environments
    //await Future.delayed(const Duration(seconds: 3));
    final userId = _authenticator.userId;

    String? token = await PushNotificationService().getFcmToken();
    if (userId != null && token != null) {
      // If user logs in from the different account, we need to update the fcm token
      saveUserInfo(UserPayload(userId: userId, fcmToken: token));
    }

    state = AuthenticationState(
        result: result,
        isLoading: false,
        userId: userId,
        page: "login"
    );
  }

  Future<void> logOut() async {
    await _authenticator.logOut();
    state = AuthenticationState.unknown();
  }

  Future<void> registerWithEmailAndPassword(
      {required String name,
        required String email,
        required String password}) async {
    state = state.copyWith(isLoading: true);

    final result =
    await _authenticator.registerWithEmailAndPassword(email, password);

    final userId = _authenticator.userId;

    String? token = await PushNotificationService().getFcmToken();

    if (result == EAuthenticationResult.success && userId != null) {
      // If user creates a new account, we need to save the device FCM token
      saveUserInfo(UserPayload(userId: userId, fcmToken: token));
    }

    state = AuthenticationState(
        result: result,
        isLoading: false,
        userId: userId,
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

    final userId = _authenticator.userId;

    String? token = await PushNotificationService().getFcmToken();

    if (result == EAuthenticationResult.success && userId != null) {
      // If user creates a new account, we need to save the device FCM token
      saveUserInfo(UserPayload(userId: userId, fcmToken: token));
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

    final userId = _authenticator.userId;

    String? token = await PushNotificationService().getFcmToken();

    if (result == EAuthenticationResult.success && userId != null) {
      saveUserInfo(UserPayload(userId: userId, fcmToken: token));
    }

    state = state.copyWith(
      isLoading: false,
      result: result,
    );
  }
}
