import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../typedefs/entity.dart';
import 'e_authentication_result.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    required EAuthenticationResult? result,
    required bool isLoading,
    required Id? userId,
    required String? page,
  }) = _AuthState;

  const AuthenticationState._();

  factory AuthenticationState.unknown() => const AuthenticationState(
    result: null,
    isLoading: false,
    userId: null,
    page: null,
  );
}
