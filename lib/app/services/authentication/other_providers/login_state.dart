import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/e_authentication_result.dart';
import '../authentication_service.dart';


part 'login_state.g.dart';

@riverpod
bool isLoggedIn(Ref ref) {
  final authProvider = ref.watch(authenticationServiceProvider);
  return authProvider.result == EAuthenticationResult.success;
}
