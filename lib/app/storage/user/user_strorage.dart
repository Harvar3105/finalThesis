
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../models/domain/user.dart';

class UserStorage {
  const UserStorage();

  Future<bool> saveOrUpdateUserInfo(UserPayload payload) async {
    try {
      var userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseUserFields.userId, isEqualTo: payload.userId)
          .limit(1)
          .get();

      Map<String, dynamic> updatedData = {};

      if (payload.firstName != null) {
        updatedData[FirebaseUserFields.firstName] = payload.firstName;
      }
      if (payload.lastName != null) {
        updatedData[FirebaseUserFields.lastName] = payload.lastName;
      }
      if (payload.phoneNumber != null) {
        updatedData[FirebaseUserFields.lastName] = payload.phoneNumber;
      }
      if (payload.email != null) {
        updatedData[FirebaseUserFields.email] = payload.email;
      }
      if (payload.avatarUrl != null) {
        updatedData[FirebaseUserFields.avatarUrl] = payload.avatarUrl;
      }
      if (payload.aboutMe != null) {
        updatedData[FirebaseUserFields.aboutMe] = payload.aboutMe;
      }
      if (payload.role != null) {
        updatedData[FirebaseUserFields.role] = payload.role;
      }
      if (payload.fcmToken != null) {
        updatedData[FirebaseUserFields.fmcToken] = payload.fcmToken;
      }

      if (userInfo.docs.isNotEmpty) {
        if (updatedData.isNotEmpty) {
          await userInfo.docs.first.reference.update(updatedData);
        }
        return true;
      }

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .add(payload.toJson());

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteUserPicture(UserPayload payload) async {
    try {
      var userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseUserFields.userId, isEqualTo: payload.userId)
          .limit(1)
          .get();

      Map<String, dynamic> updatedData = {};

      if (payload.firstName != null) {
        updatedData[FirebaseUserFields.firstName] = payload.firstName;
      }
      if (payload.lastName != null) {
        updatedData[FirebaseUserFields.lastName] = payload.lastName;
      }
      if (payload.phoneNumber != null) {
        updatedData[FirebaseUserFields.lastName] = payload.phoneNumber;
      }
      if (payload.email != null) {
        updatedData[FirebaseUserFields.email] = payload.email;
      }
      if (payload.aboutMe != null) {
        updatedData[FirebaseUserFields.aboutMe] = payload.aboutMe;
      }
      if (payload.role != null) {
        updatedData[FirebaseUserFields.role] = payload.role;
      }
      if (payload.fcmToken != null) {
        updatedData[FirebaseUserFields.fmcToken] = payload.fcmToken;
      }

      updatedData[FirebaseUserFields.avatarUrl] = null;

      if (userInfo.docs.isNotEmpty) {
        if (updatedData.isNotEmpty) {
          await userInfo.docs.first.reference.update(updatedData);
        }
        return true;
      }

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .add(payload as Map<String, dynamic>);

      return true;
    } catch (_) {
      return false;
    }
  }
}
