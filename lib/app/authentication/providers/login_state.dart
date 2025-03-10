import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_result.dart';


part 'login_state.g.dart';

@riverpod
bool isLoggedIn(Ref ref) {
  final authProvider = ref.watch(authenticationProvider);
  return authProvider.result == AuthResult.success;
}
