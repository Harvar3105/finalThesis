import 'package:final_thesis_app/app/storage/user/user_payload_provider.dart';
import 'package:final_thesis_app/app/storage/user/users_friends.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/domain/user.dart';
import '../../services/authentication/providers/user_id.dart';

part 'combined_user_friends.g.dart';

@riverpod
Future<(User?, List<User>)> combinedUserWithFriends(Ref ref) async {
  final userId = ref.read(userIdProvider);

  if (userId == null) {
    return (null, [].cast<User>());
  }

  final user = (await ref.watch(userPayloadProvider(userId).future)).userFromPayload();

  if (user == null || user.friends.isEmpty) {
    return (user, [].cast<User>());
  }

  final friends = await ref.watch(usersFriendsProvider(user.friends).future);

  return (user, friends);
}