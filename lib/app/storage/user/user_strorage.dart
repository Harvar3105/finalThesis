
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../models/domain/user.dart';

class UserStorage {
  const UserStorage();

  Future<bool> saveOrUpdateUserInfo(UserPayload payload) async {
    try {
      late DocumentReference userRef;
      if (payload.id == null) {
        userRef = FirebaseFirestore.instance.collection(FirebaseCollectionNames.users).doc();
      } else {
        userRef = FirebaseFirestore.instance.collection(FirebaseCollectionNames.users).doc(payload.id);
      }
      final generatedId = userRef.id;
      final updatedData = <String, Object?>{};
      final newPayload = payload.copyWith(id: generatedId);
      newPayload.toJson().entries.where((entry) => entry.value != null).forEach((entry) {

        log('entry.key: ${entry.key}');
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

  Future<bool> deleteUserPicture(UserPayload payload) async {
    try {
      var userInfo = await FirebaseFirestore.instance
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
