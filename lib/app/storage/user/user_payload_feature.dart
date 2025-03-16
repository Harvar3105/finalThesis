import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../models/domain/user.dart';
import '../../typedefs/entity.dart';

part 'user_payload_feature.g.dart';

@riverpod
Future<UserPayload> userPayloadFeature(Ref ref, Id id) async {
  final doc = await FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(id)
      .get();

  if (!doc.exists) {
    throw Exception("No user found with id: $id");
  }

  log('userPayloadFeature: ${doc.data()}');
  return UserPayload.fromJson(doc.data()!);
}