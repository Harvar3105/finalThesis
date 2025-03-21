import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/app/models/domain/user.dart';
import 'package:final_thesis_app/app/typedefs/e_sorting_order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../typedefs/e_role.dart';
import '../../typedefs/entity.dart';

@riverpod
Future<List<User>> searchUsersByName(
    String searchingSubstring,
    int type,
    Id currentUserId,
    ERole role,
    ESortingOrder sortingOrder
  ) async {
  log('usersByName: Called with name = $searchingSubstring');

  dynamic snapshot = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users);

  switch (role) {
    case ERole.coach:
      snapshot = snapshot.where(FirebaseFields.role, isEqualTo: ERole.coach.toString());
      break;
    case ERole.athlete:
      snapshot = snapshot.where(FirebaseFields.role, isEqualTo: ERole.athlete.toString());
      break;
    case ERole.none:
      break;
  }
  snapshot = await snapshot.get();

  List<User> users = snapshot.docs
      .map((doc) => UserPayload.fromJson(doc.data()).userFromPayload())
      .cast<User>()
      .toList();

  final currentUser = users.firstWhere((user) => user.id == currentUserId);
  users.removeWhere((user) => user.id == currentUserId);

  List<User>? selectedTypeUsers;
  switch (type) {
    case 0:
      selectedTypeUsers = users.where((listUser) =>
        currentUser.friends?.contains(listUser.id) ?? false
      ).toList();
      break;
    case 2:
      selectedTypeUsers = users.where((listUser) =>
        (currentUser.friendRequests?.contains(listUser.id) ?? false) ||
        (currentUser.sentFriendRequests?.contains(listUser.id) ?? false)
      ).toList();
      break;
  }
  selectedTypeUsers ??= users;

  var filteredUsers;
  searchingSubstring == ""
      ? filteredUsers = users
      : filteredUsers = selectedTypeUsers
      .where((user) => checkUsersName(user, searchingSubstring))
      .toList();

  filteredUsers.sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));

  return filteredUsers;
}

bool checkUsersName(User user, String searchingSubstring) {
  var name = '${user.firstName} ${user.lastName}';
  if (name.toLowerCase().contains(searchingSubstring.toLowerCase())) return true;
  return false;
}