import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../models/domain/user.dart';

part 'users_payloads.g.dart';

@riverpod
Stream<List<UserPayload>> usersPayloads(Ref ref) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => UserPayload.fromJson(doc.data()))
      .toList());
}