
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/app/models/domain/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';

part 'all_users.g.dart';

@riverpod
Stream<Iterable<UserPayload>> allUsers(Ref ref) {
  final controller = StreamController<Iterable<UserPayload>>();

  final sub = FirebaseFirestore.instance
      .collection(
    FirebaseCollectionNames.users,
  )
      .orderBy(
    FirebaseUserFields.createdAt,
    descending: true,
  )
      .snapshots()
      .listen(
        (snapshots) {
      final users = snapshots.docs.map(
            (doc) => UserPayload
                .fromJson(doc.data())
                .copyWith(userId: doc.id),
      );
      controller.sink.add(users);
    },
  );

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
}