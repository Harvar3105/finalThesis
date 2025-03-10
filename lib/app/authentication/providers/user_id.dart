import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../typedefs/entity.dart';

part 'user_id.g.dart';

@riverpod
Id? userId(Ref ref) {
  return ref.watch(authenticationProvider).userId;
}
