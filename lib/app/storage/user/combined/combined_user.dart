import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/domain/user.dart';
import '../../../services/authentication/providers/user_id.dart';
import '../user_payload.dart';
import '../users_by_ids.dart';

part 'combined_user.g.dart';

@riverpod
Future<(User?, List<User>)> combinedUser(Ref ref, FirebaseFields field) async {
  final userId = ref.read(userIdProvider);

  if (userId == null) {
    return (null, [].cast<User>());
  }

  final userPayload = (await ref.watch(userPayloadProvider(userId).future));
  final user = userPayload.userFromPayload();

  if (user == null || user.friends.isEmpty) {
    return (user, [].cast<User>());
  }
  final Map<String, dynamic> userMap = userPayload.toJson();
  var ids = userMap[field.toString()];

  final friends = await ref.watch(usersByIdsProvider(ids).future);

  return (user, friends);
}