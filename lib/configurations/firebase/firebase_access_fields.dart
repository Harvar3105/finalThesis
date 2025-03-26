import 'dart:developer';

import 'package:flutter/foundation.dart';

@immutable
class FirebaseCollectionNames {
  static const users = 'users';

  const FirebaseCollectionNames._();
}

@immutable
class FirebaseFields {
  // Shared
  static const id = 'id';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';

  // User related
  static const firstName = 'first_name';
  static const lastName = 'last_name';
  static const phoneNumber = 'phone_number';
  static const email = 'email';
  static const avatarUrl = 'avatar_url';
  static const aboutMe = 'about_me';
  static const role = 'role';
  static const fcmToken = 'fmc_token';
  static const friends = 'friends';
  static const friendRequests = 'friend_requests';
  static const sentFriendRequests = 'sent_friend_requests';
  static const blockedUsers = 'blocked_users';


  static const allFields = {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'phone_number': phoneNumber,
    'email': email,
    'avatar_url': avatarUrl,
    'about_me': aboutMe,
    'role': role,
    'fmc_token': fcmToken,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'friends': friends,
    'friend_requests': friendRequests,
    'sent_friend_requests': sentFriendRequests,
    'blocked_users': blockedUsers,
  };

  static String mapFirebaseField(String payloadField) {
    final result = allFields[payloadField];
    if (result == null) {
      log('Unknown field: $payloadField');
      return 'unknownField';
    }
    return result;
  }
}