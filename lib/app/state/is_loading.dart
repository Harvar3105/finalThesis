import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/view_models/authentication/authentication_state_model.dart';



part 'is_loading.g.dart';

@riverpod
bool isLoading(Ref ref) {
  final authProvider = ref.watch(authenticationStateModelProvider);

  return authProvider.isLoading;
}
