import 'dart:developer';

import 'package:flutter/foundation.dart';

@immutable
class FirebaseCollectionNames {
  static const users = 'users';
  static const events = 'events';

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
  static const avatarThumbnailUrl = 'avatar_thumbnail_url';
  static const aboutMe = 'about_me';
  static const role = 'role';
  static const fcmToken = 'fmc_token';
  static const friends = 'friends';
  static const friendRequests = 'friend_requests';
  static const sentFriendRequests = 'sent_friend_requests';
  static const blockedUsers = 'blocked_users';

  // Event related
  static const creatorId = 'creator_id';
  static const friendId = 'friend_id';
  static const start = 'start';
  static const end = 'end';
  static const title = 'title';
  static const description = 'description';
  static const location = 'location';
  static const type = 'type';
  static const privacy = 'privacy';
  static const counterOfferOf = 'counter_offer_of';
  static const notifyBefore = 'notify_before';


  static const allFields = {
    // Shared
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,

    // User related
    'first_name': firstName,
    'last_name': lastName,
    'phone_number': phoneNumber,
    'email': email,
    'avatar_url': avatarUrl,
    'avatar_thumbnail_url': avatarThumbnailUrl,
    'about_me': aboutMe,
    'role': role,
    'fmc_token': fcmToken,
    'friends': friends,
    'friend_requests': friendRequests,
    'sent_friend_requests': sentFriendRequests,
    'blocked_users': blockedUsers,

    // Event related
    'creator_id': creatorId,
    'friend_id': friendId,
    'start': start,
    'end': end,
    'title': title,
    'description': description,
    'location': location,
    'type': type,
    'privacy': privacy,
    'counter_offer_of': counterOfferOf,
    'notify_before': notifyBefore,
  };

  static String mapFirebaseField(String payloadField) {
    final result = allFields[payloadField];
    if (result == null) {
      log('Unknown field: $payloadField');
      return 'unknownField';
    }
    return result;
  }

  const FirebaseFields._();
}