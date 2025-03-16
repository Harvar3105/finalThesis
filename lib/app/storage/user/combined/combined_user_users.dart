import 'package:final_thesis_app/app/storage/user/all_users.dart';
import 'package:final_thesis_app/app/storage/user/user_payload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/domain/user.dart';
import '../../../services/authentication/providers/user_id.dart';
import '../user_payload_feature.dart';

part 'combined_user_users.g.dart';

@riverpod
Future<(User?, List<User>)> combinedUserWithUsers(Ref ref) async {
  final userId = ref.read(userIdProvider);

  if (userId == null) {
    return (null, [].cast<User>());
  }

  final user = (await ref.watch(userPayloadFeatureProvider(userId).future)).userFromPayload();

  if (user == null) {
    return (user, [].cast<User>());
  }

  final users = await ref.watch(allUsersProvider.future);
  users.toList().removeWhere((u) => u.id == user.id);
  final List<User> result = users
    .map((u) => u.userFromPayload())
    .where((u) => u != null)
    .cast<User>()
    .toList();

  return (user, result);
}