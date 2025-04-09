import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../authentication_state_model.dart';
import '../models/e_authentication_result.dart';

part 'login_state.g.dart';


@riverpod
bool isLoggedIn(Ref ref) {
  final authProvider = ref.watch(authenticationStateModelProvider);
  return authProvider.result == EAuthenticationResult.success;
}
