import 'package:flutter/foundation.dart';

@immutable
class FirebaseCollectionNames {
  static const users = 'users';

  const FirebaseCollectionNames._();
}

@immutable
class FirebaseUserFields {
  static const userId = 'uid';
  static const firstName = 'first_name';
  static const lastName = 'last_name';
  static const phoneNumber = 'phone_number';
  static const email = 'email';
  static const avatarUrl = 'avatar_url';
  static const aboutMe = 'about_me';
  static const role = 'role';
  static const fmcToken = 'fmc_token';
}