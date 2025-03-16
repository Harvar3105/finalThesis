import 'dart:developer';

import 'package:final_thesis_app/app/storage/user/user_payload_feature.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/domain/user.dart';
import '../../../services/authentication/providers/user_id.dart';
import '../user_payload.dart';
import '../users_by_ids.dart';

part 'combined_user.g.dart';

@riverpod
Future<(User?, List<User>)> combinedUser(Ref ref, String field) async {
  try {
    final userId = ref.read(userIdProvider);
    if (userId == null) throw Exception("User id is null");

    final userPayload = (await ref.watch(userPayloadFeatureProvider(userId).future));
    final user = userPayload.userFromPayload();
    if (user == null) throw Exception("User is null. payload: $userPayload and user itself: $user");

    final Map<String, dynamic> userMap = userPayload.toJson();
    var ids = userMap[field];
    if (ids == null || ids.isEmpty) throw Exception("Ids are null or empty");

    final result = await ref.watch(usersByIdsProvider(ids).future);
    if (result.isEmpty) return (user, result);

    result.removeWhere((u) => u.id == userId);
    return (user, result);
  } catch (error, stackTrace) {
    log('${error.toString()}, ${stackTrace.toString()}');
    return (null, [].cast<User>());
  }
}