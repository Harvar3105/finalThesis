import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/typedefs/entity.dart';
import '../authentication_state_model.dart';

part 'user_id.g.dart';

@riverpod
Id? userId(Ref ref) {
  return ref.watch(authenticationStateModelProvider).id;
}
