import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/authentication/authentication_service.dart';



part 'is_loading.g.dart';

// TODO(all): Will add more providers here later
@riverpod
bool isLoading(Ref ref) {
  final authProvider = ref.watch(authenticationServiceProvider);

  return authProvider.isLoading;
}
