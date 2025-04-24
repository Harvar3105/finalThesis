
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/app/typedefs/entity.dart';

import '../../../app/typedefs/e_role.dart';
import '../../../app/typedefs/e_sorting_order.dart';
import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../domain/user.dart';
import '../authentication/authenticator.dart';
import '../repository.dart';

class UserStorage extends Repository<FirebaseFirestore> {
  final Authenticator authenticator;

  UserStorage(this.authenticator) : super(FirebaseFirestore.instance);

  Future<bool> saveOrUpdateUserInfo(UserPayload payload) async {
    log("saveOrUpdateUserInfo: $payload");

    try {
      final Id? userId = payload.id ?? authenticator.id;

      final userRef = base
          .collection(FirebaseCollectionNames.users)
          .doc(userId);

      final updatedData = <String, Object?>{};
      final newPayload = payload.copyWith(id: userId);

      newPayload.toJson().entries.where((entry) => entry.value != null).forEach((entry) {
        final firebaseField = FirebaseFields.mapFirebaseField(entry.key);
        updatedData[firebaseField] = entry.value as Object;
      });

      await userRef.set(updatedData, SetOptions(merge: true));

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Id? getCurrentUserId() {
    return authenticator.id;
  }

  Future<UserPayload?> getCurrentUser() async {
    try {
      final Id? userId = authenticator.id;

      if (userId == null) throw Exception("Cannot get current user id!");
      
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFields.id, isEqualTo: userId)
          .limit(1)
          .get();
      
      return UserPayload.fromJson(querySnapshot.docs.first.data());
    }catch (error) {
      log("Cannot get current user! Error $error");
      return null;
    }
  }

  Stream<UserPayload?> watchCurrentUser() {
    final Id? userId = authenticator.id;
    if (userId == null) {
      return Stream.error(Exception("Cannot get current user id!"));
    }

    return base
        .collection(FirebaseCollectionNames.users)
        .where(FirebaseFields.id, isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return null;
      return UserPayload.fromJson(querySnapshot.docs.first.data());
    }).handleError((error) {
      log("Cannot get current user! Error $error");
    });
  }

  Future<List<UserPayload>?> getAllUsers() async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.users)
          .orderBy(FirebaseFields.createdAt, descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => UserPayload.fromJson(doc.data()))
          .toList();
    } catch (error) {
      log("Cannot get all users! Error $error");
      return null;
    }
  }
  
  Future<UserPayload?> gerUserById(String id) async {
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFields.id, isEqualTo: id)
          .limit(1)
          .get();

      return UserPayload.fromJson(querySnapshot.docs.first.data());
    }catch (error) {
      log("Cannot get user with id $id! Error $error");
      return null;
    }
  }
  
  Future<List<UserPayload>?> getUsersByIds(Set<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      final querySnapshot = await base
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFields.id, whereIn: ids)
          .get();

      return querySnapshot.docs
          .map((doc) => UserPayload.fromJson(doc.data()))
          .toList();
    } catch (error) {
      log("Cannot get user with ids $ids! Error $error");
      return null;
    }
  }

  Future<List<UserPayload>?> getUsersFriends(UserPayload user) async {
    if (user.friends == null || user.friends!.isEmpty) return [];
    try {
      final querySnapshot = await base
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFields.id, whereIn: user.friends)
          .get();

      return querySnapshot.docs
          .map((doc) => UserPayload.fromJson(doc.data()))
          .toList();
    }catch (error) {
      log("Cannot get user friends for user $user! Error $error");
      return null;
    }
  }

  Future<bool> deleteUserPicture(UserPayload payload) async {
    try {
      var userInfo = await base
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFields.id, isEqualTo: payload.id)
          .limit(1)
          .get();

      final updatedData = Map.fromEntries(
        payload.toJson().entries.where((entry) => entry.value != null).map(
              (entry) => MapEntry(
            FirebaseFields.mapFirebaseField(entry.key),
            entry.value,
          ),
        ),
      );
      updatedData[FirebaseFields.avatarUrl] = null;
      updatedData[FirebaseFields.avatarThumbnailUrl] = null;

      if (userInfo.docs.isNotEmpty) {
        if (updatedData.isNotEmpty) {
          await userInfo.docs.first.reference.update(updatedData);
        }
        return true;
      }

      await base
          .collection(FirebaseCollectionNames.users)
          .add(payload as Map<String, dynamic>);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<UserPayload>?> searchUsersByName(
      String searchingSubstring,
      int type,
      Id currentUserId,
      ERole role,
      ESortingOrder sortingOrder
      ) async {

    log("usersByName: Called with name $searchingSubstring\ntype $type\nrole $role\nsortingOrder $sortingOrder");

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

    List<UserPayload> users = snapshot.docs
        .map((doc) => UserPayload.fromJson(doc.data()))
        .cast<UserPayload>()
        .toList();

    final currentUser = users.firstWhere((user) => user.id == currentUserId);
    users.removeWhere((user) => user.id == currentUserId);

    List<UserPayload>? selectedTypeUsers = [];
    switch (type) {
      case 0:
        if (currentUser.friends == null) break;

        selectedTypeUsers = users.where((listUser) =>
        currentUser.friends?.contains(listUser.id) ?? false
        ).toList();
        log("current user friends: ${currentUser.friends}");
        break;
      case 1:
        selectedTypeUsers = users;
        break;
      case 2:
        if (currentUser.friendRequests == null) break;

        selectedTypeUsers = users.where((listUser) =>
        (currentUser.friendRequests?.contains(listUser.id) ?? false) ||
            (currentUser.sentFriendRequests?.contains(listUser.id) ?? false)
        ).toList();
        break;
    }
    if (selectedTypeUsers.isEmpty) return null;

    List<UserPayload> filteredUsers;
    searchingSubstring == ""
        ? filteredUsers = users
        : filteredUsers = selectedTypeUsers
        .where((user) => checkUsersName(user, searchingSubstring))
        .toList();

    filteredUsers.sort((a, b) => '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}'));
    log("Search results: ${filteredUsers.length}");
    return filteredUsers;
  }

  bool checkUsersName(UserPayload user, String searchingSubstring) {
    var name = '${user.firstName} ${user.lastName}';
    if (name.toLowerCase().contains(searchingSubstring.toLowerCase())) return true;
    return false;
  }
}
