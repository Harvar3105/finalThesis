import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../models/domain/user.dart';

part 'users_friends.g.dart';

@riverpod
Future<List<User>> usersFriends(Ref ref, Set<String> usersIds) async {
  log('usersFriendsProvider: Called with usersIds = $usersIds');
  if (usersIds.isEmpty) {
    log('usersFriendsProvider: no friends, return empty list');
    return [];
  }

  final snapshot = await FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .where(FirebaseFields.id, whereIn: usersIds)
      .get();

  return snapshot.docs
      .map((doc) => UserPayload.fromJson(doc.data()).userFromPayload())
      .cast<User>()
      .toList();
}