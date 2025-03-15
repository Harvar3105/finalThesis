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
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'email': email,
    'avatarUrl': avatarUrl,
    'aboutMe': aboutMe,
    'role': role,
    'fcmToken': fcmToken,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'friends': friends,
    'friendRequests': friendRequests,
    'sentFriendRequests': sentFriendRequests,
    'blockedUsers': blockedUsers,
  };

  static String mapFirebaseField(String payloadField) {
    return allFields[payloadField] ?? 'unknownField';
  }
}