import 'package:freezed_annotation/freezed_annotation.dart';

import '../../typedefs/entity.dart';
import 'auth_result.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthResult? result,
    required bool isLoading,
    required Id? userId,
    required String? page,
  }) = _AuthState;

  const AuthState._();

  factory AuthState.unknown() => const AuthState(
    result: null,
    isLoading: false,
    userId: null,
    page: null,
  );
}
