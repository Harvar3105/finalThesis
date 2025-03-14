import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/domain/user.dart';
import '../../typedefs/entity.dart';

part 'user_payload_provider.g.dart';

@riverpod
Stream<UserPayload> userPayload(Ref ref, Id id) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .where(FirebaseUserFields.userId, isEqualTo: id)
      .limit(1)
      .snapshots()
      .where((snapshot) => snapshot.docs.isNotEmpty)
      .map((snapshot) {
    final doc = snapshot.docs.first;
    return UserPayload.fromJson(doc.data());
  });
}
